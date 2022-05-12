class Account::Billing::Subscriptions::IncludedPricesController < Account::ApplicationController
  account_load_and_authorize_resource :included_price, through: :subscription, through_association: :included_prices

  # GET /account/billing/subscriptions/:subscription_id/included_prices
  # GET /account/billing/subscriptions/:subscription_id/included_prices.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @subscription]
  end

  # GET /account/billing/subscriptions/included_prices/:id
  # GET /account/billing/subscriptions/included_prices/:id.json
  def show
  end

  # GET /account/billing/subscriptions/:subscription_id/included_prices/new
  def new
  end

  # GET /account/billing/subscriptions/included_prices/:id/edit
  def edit
  end

  # POST /account/billing/subscriptions/:subscription_id/included_prices
  # POST /account/billing/subscriptions/:subscription_id/included_prices.json
  def create
    respond_to do |format|
      if @included_price.save
        format.html { redirect_to [:account, @subscription, :included_prices], notice: I18n.t("billing/subscriptions/included_prices.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @included_price] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @included_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/billing/subscriptions/included_prices/:id
  # PATCH/PUT /account/billing/subscriptions/included_prices/:id.json
  def update
    respond_to do |format|
      if @included_price.update(included_price_params)
        format.html { redirect_to [:account, @included_price], notice: I18n.t("billing/subscriptions/included_prices.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @included_price] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @included_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/billing/subscriptions/included_prices/:id
  # DELETE /account/billing/subscriptions/included_prices/:id.json
  def destroy
    @included_price.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @subscription, :included_prices], notice: I18n.t("billing/subscriptions/included_prices.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def included_price_params
    params.require(:billing_subscriptions_included_price).permit(
      :price_id,
      :quantity
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
