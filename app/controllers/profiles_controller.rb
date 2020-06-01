class ProfilesController < BaseController
  before_action :require_regular

  def show
    @user = current_user
    @orders = Order.all
  end
end