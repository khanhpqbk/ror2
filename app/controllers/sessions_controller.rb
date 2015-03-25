class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if(user && user.authenticate(params[:session][:password]))
      # log in user and redirect to the user's showing page
      log_in user
      redirect_to user
    else
      # create an error message
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
end
