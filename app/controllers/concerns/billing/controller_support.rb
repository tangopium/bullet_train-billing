module Billing::ControllerSupport
  extend ActiveSupport::Concern

  def managing_billing?
    self.class.module_parents.include?(Account::Billing)
  end

  def enforce_billing_requirements
    unless managing_billing? || switching_teams? || managing_account?
      if current_team.needs_billing_subscription?
        redirect_to [:new, :account, current_team, :billing_subscription]
      end
    end
  end
end
