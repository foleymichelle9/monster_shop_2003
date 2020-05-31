class BaseController < ApplicationController

  def require_regular
    render file: "/public/404" unless current_regular?
  end
end