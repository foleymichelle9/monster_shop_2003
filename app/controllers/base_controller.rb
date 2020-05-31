class BaseController < ApplicationController

  def require_regular
    render file: "/public/404" unless current_regular?
  end

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end

  def require_admin
    render file: "/public/404" unless current_admin?
  end

  def require_non_admin
    render file: "/public/404" unless !current_user || current_merchant? || current_regular?
  end
end