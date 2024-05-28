class Billing::Subscription < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :team
  belongs_to :provider_subscription, dependent: :destroy, polymorphic: true
  belongs_to :product, class_name: "Billing::Product"
  belongs_to :price, class_name: "Billing::Price"
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  scope :active, -> { where.not(status: ["initiated", "canceled"]) }
  scope :not_canceled, -> { where.not(status: "canceled") }
  scope :canceled, -> { where(status: "canceled") }
  # 🚅 add scopes above.

  PROVIDER_SUBSCRIPTION_TYPES = I18n.t("billing/subscriptions.fields.provider_subscription_type.options").keys.map(&:to_s)

  validates :provider_subscription_type, inclusion: {
    in: PROVIDER_SUBSCRIPTION_TYPES, allow_blank: false, message: I18n.t("errors.messages.empty")
  }
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  PENDING_STATUSES = ["initiated", "pending"]
  ACTIVE_STATUSES = ["trialing", "active", "overdue", "canceling"]

  def build_provider_subscription(params = {})
    raise "invalid provider subscription type" unless provider_subscription_type_valid?
    self.provider_subscription = provider_subscription_type.constantize.new(params)
  end

  def provider_subscription_type_valid?
    PROVIDER_SUBSCRIPTION_TYPES.include?(provider_subscription_type)
  end

  def active?
    ACTIVE_STATUSES.include?(status)
  end

  def pending?
    PENDING_STATUSES.include?(status)
  end

  # TODO: Is this where this should live? We need to distinguish between included_prices and
  # available_prices for the sake of Umbrella Subscriptions. An Umbrella Subscription is only
  # connected to prices via the subscription of the covering team. Maybe this gem should
  # define a basic verison of available_prices that just returns included_prices and then the
  # umbrella_subscriptions gem could monkeypatch with this version?
  def available_prices
    if defined?(BulletTrain::Billing::UmbrellaSubscriptions) && umbrella?
      provider_subscription.covering_team.current_billing_subscription.available_prices
    else
      [self.price]
    end
  end

  # TODO: Maybe this should go in the umbrella_subscriptions gem?
  def umbrella?
    provider_subscription_type == "Billing::Umbrella::Subscription"
  end

  # TODO: Maybe this should go in the umbrella_subscriptions gem?
  def covering_team
    provider_subscription.covering_team
  end

  def valid_umbrella?
    umbrella? && provider_subscription.covering_team&.can_extend_umbrella_subscriptions?
  end

  def upgradeable?
    product.can_upgrade_to.present? && product.can_upgrade_to.any?
  end
  # 🚅 add methods above.
end
