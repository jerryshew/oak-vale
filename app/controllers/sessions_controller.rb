class SessionsController < ApplicationController

	def new
		if signed_in?
			redirect_to root_path
		end
	end

	def create
		@user = User.find_by(email: session_params[:email].downcase)
		if @user && @user.authenticate(session_params[:password])
			params[:remember_me]? sign_in_permanent(@user) : sign_in(@user)

			flash[:success] = 'Welcome back, ' + @user.name
			redirect_to @user
		else
			flash[:error] = 'Invalid email/password' 
      render 'new'
		end
	end

	def destroy
		sign_out
		flash[:success] = "Sign out"
		redirect_to root_path
	end

	private
		def session_params
			params.require(:session).permit(:email, :password, :remember_me)
		end
end
