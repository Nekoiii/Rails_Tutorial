class SessionsController < ApplicationController

  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user &. authenticate(params[:session][:password])

    else
      # flash.now: unlike redirect, flash will remain when using request, so should use flash.now instead of flash here.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end  end

  def destroy
  end

end
