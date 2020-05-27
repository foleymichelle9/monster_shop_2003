class SessionsController < ApplicationController
    def new
    end

    def create
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            flash[:success] = "Welcome #{user.name}"
            redirect_to ("/profile")
        else
            flash[:error] = "Incorrect username or password"
            redirect_to new_session_path
        end
        
    end
    
    
    
end