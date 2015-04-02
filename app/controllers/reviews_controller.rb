class ReviewsController < ApplicationController

  before_action :authenticate_user!

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def show

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

  def destroy
    @review = Review.find(params[:id])
    if current_user.id == @review.user_id
      @review.destroy
      flash[:notice] = "Review has been deleted"
      redirect_to restaurants_path
    else
      flash[:notice] = "You can only delete reviews you have created"
      redirect_to restaurants_path
    end
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end
end



