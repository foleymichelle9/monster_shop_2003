class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:id])
  end

  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:id])
    if params[:active] == "false"
      merchant.update(active?: false)
      flash[:notice] = "Merchant #{merchant.id} has been disabled"
    elsif params[:active] == "true"
      merchant.update(active?: true)
      flash[:notice] = "Merchant #{merchant.id} has been enabled"
    end
    redirect_to admin_merchants_path
  end
  
  
end