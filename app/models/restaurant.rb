class Restaurant < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  belongs_to :user
  validates :name, length: {minimum: 3}, uniqueness: true

  def create_review(user, params)
    new_review = reviews.build(params)
    new_review.user = user
    new_review.save
    new_review 
  end

  def average_rating
    if reviews.any?
      avrg = 0
      reviews.each { |review| avrg += review.rating  }
      avrg / reviews.count
    else
      'N/A'
    end
  end
end
