class StaticPagesController < ApplicationController
	def home
		
		if logged_in?
			@micropost = current_user.microposts.build
			@feed_items = current_user.feed.paginate(page: params[:page])
		end
	end

	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created"
			redirect_to root_url
		else
			render 'static_pages/home'
		end
	end

	def news
	end

	def contact
	end

	def about
	end

	def micropos_params
		params.require(:micropost).permit(:content)
	end
end
