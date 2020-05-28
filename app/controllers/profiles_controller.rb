class ProfilesController < ApplicationController

  def show

    @user = current_user
    @orders = Order.all
  end
end