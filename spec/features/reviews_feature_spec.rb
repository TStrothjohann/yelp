require 'rails_helper'

feature 'reviewing' do
  before {Restaurant.create name: 'KFC'}

  scenario 'allows users to leave a review using a form' do
     visit '/restaurants'
     user_login
     click_link 'Review KFC'
     fill_in "Thoughts", with: "such a shit"
     select '1', from: 'Rating'
     click_button 'Leave Review'

     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('such a shit')
  end

  scenario "Users can only leave one review per restaurant" do
    leave_review
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "wow"
    select '4', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).not_to have_content('wow')
  end

end