class Merchant::ItemsController < Merchant::BaseController
  
  def index
    @merchant = Merchant.find(current_user.merchant_id) if current_merchant? 
  end
  
  def update
    item = Item.find(params[:id])
    if params[:active] == "false"
      item.update(active?: false)
      flash[:notice] = "You have disabled item #{item.id}"
    elsif params[:active] == "true"
      item.update(active?: true)
      flash[:notice] = "You have enabled item #{item.id}"
    end
    redirect_to merchant_items_path 
  end
  
end