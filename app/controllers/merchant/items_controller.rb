class Merchant::ItemsController < Merchant::BaseController
  
  def index
    @merchant = Merchant.find(current_user.merchant_id) if current_merchant? 
  end

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @item = Item.new
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    item = merchant.items.create(item_params)
    if item.save 
      flash[:message] = "Item #{item.id} has been created"
      redirect_to merchant_items_path
    else
      flash[:error] = "Input valid info"
      redirect_to new_merchant_item_path
    end
    
  end
  
  
  
  def update
    item = Item.find(params[:id])
    case params[:edit]
    when "active_false"
      item.update(active?: false)
      flash[:notice] = "You have disabled item #{item.id}"
    when "active_true"
      item.update(active?: true)
      flash[:notice] = "You have enabled item #{item.id}"
    end
    redirect_to merchant_items_path 
  end

  def destroy
    Item.destroy(params[:id])
    flash[:notice] = "Item #{params[:id]} has been deleted"
    redirect_to merchant_items_path 
  end
  

  private 

  def item_params
    default_image
    params.require(:item).permit(:name, :description, :image, :price, :inventory)
  end

  def default_image
    default_url ='https://www.pngitem.com/pimgs/m/187-1877177_packaging-box-opened-outline-box-outline-hd-png.png'
    params[:item][:image] = default_url if params[:item][:image].empty?
  end
  
  
  
end