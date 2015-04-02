require 'spec_helper'


describe Restaurant, :type => :model do
  let(:restaurant){Restaurant.create name: "kf"}
  let(:user){User.create id: 3, email: "thomas@test.de", password: "testtest", password_confirmation: "testtest"}
  let(:review_params){{thoughts: "Wow Great restaurant.", rating: 3}}

  it 'is not valid with a name of less than three characters' do
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it "is not valid unless it has a unique name" do
    Restaurant.create(name: "Moe's Tavern")
    restaurant = Restaurant.new(name: "Moe's Tavern")
    expect(restaurant).to have(1).error_on(:name)
  end

  it "can store a related review" do
    review = restaurant.create_review(user, review_params)
    expect(review.user_id).to eq(3)
  end
end

describe '#average_rating' do
  let(:restaurant){Restaurant.create name: 'The Ivy'}

  context 'no reviews' do
    it 'returns "N/A" when there are no reviews' do
      expect(restaurant.average_rating).to eq 'N/A'
    end
  end

  context '1 review' do
    it 'returns that rating' do
      restaurant.reviews.create(rating: 4)
      expect(restaurant.average_rating).to eq 4
    end
  end

  context 'multiple reviews' do
    it 'returns the average' do
      restaurant.reviews.create(rating: 1)
      restaurant.reviews.create(rating: 5)
      expect(restaurant.average_rating).to eq 3
    end
  end
end