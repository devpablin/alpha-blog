class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "Ingresaste correctamente"
      redirect_to user_path(user)
    else
      flash.now[:danger] = "Ingresaste algun dato incorrecto en tu informacion de inicio de sesion putito :V"
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Cerraste la sesion correctamente"
    redirect_to root_path
  end
end
