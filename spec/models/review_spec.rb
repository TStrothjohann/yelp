require 'spec_helper'

describe Review, :type => :model do
  before {Restaurant.create name: 'KFC'}
  
  it 'is invalid if the rating is more than 5' do
    review = Restaurant.find_by(name: 'KFC').reviews.create(rating: 6)
    expect(review).to have(1).error_on(:rating)
  end

end