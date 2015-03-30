class Review < ActiveRecord::Base
  belongs_to :restaurant
  validates :rating, numericality: { less_than_or_equal_to: 5 }
end
