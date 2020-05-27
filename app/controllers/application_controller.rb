class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

<<<<<<< HEAD
end
=======
  def current_user
    user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
>>>>>>> 6bc6cbe2022002ed5ade01e0e23f9ae76ac98691
