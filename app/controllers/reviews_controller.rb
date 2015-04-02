class ReviewsController < ApplicationController

  before_action :authenticate_user!

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    restaurant = Restaurant.find(params[:restaurant_id])
    
    if current_user.has_reviewed? restaurant
      flash[:notice] = "You can only write one review per restaurant"
      redirect_to restaurants_path
    else
      new_review = restaurant.create_review current_user, review_params
      flash[:notice] = "Review created" if new_review.save
      redirect_to restaurants_path
    end
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end
end



