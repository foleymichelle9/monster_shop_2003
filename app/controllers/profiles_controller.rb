class ProfilesController < BaseController
  before_action :require_regular

  def show
    @user = current_user
    # @orders = @user.orders
  end
end