module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
	end

	def current_user
		if user_id = session[:user_id]
			@current_user ||= Employee.find_by(id: user_id)
		elsif user_id = cookies.signed[:user_id]
			user = Employee.find_by(id: user_id)
			if user && user.remember_token_authenticated?(cookies[:remember_token])
				log_in(user)
				@current_user = user
			end
		end
	end

	def current_user?(user)
		current_user == user
	end

	def logged_in?
		!current_user.nil?
	end

	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def store_location
		session[:return_to] = request.url if request.get?
	end

	def non_logged_in_user_must_log_in
      unless logged_in?
        store_location
        flash[:warning] = "Please sign in"
        redirect_to login_path
      end
    end

    def only_site_admin_can_access
    	unless current_user.isAdmin?
    		redirect_to current_user
    	end
    end

end
