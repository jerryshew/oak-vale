class SessionsController < ApplicationController

	def new
		if signed_in?
			redirect_to root_path
		end
	end

	def create
		@user = User.find_by(email: session_params[:email].downcase)
		if @user && @user.authenticate(session_params[:password])
			if params[:remember_me]
				sign_in_permanent @user
			else
				sign_in @user
			end

			flash[:success] = 'Welcome back, ' + @user.name
			redirect_to @user
		else
			flash[:error] = '不正确的Email及密码组合！' 
      render 'new'
		end
	end

	def destroy
		sign_out
		flash[:success] = "已退出"
		redirect_to root_path
	end

	private
		def session_params
			params.require(:session).permit(:email, :password, :remember_me)
		end
end