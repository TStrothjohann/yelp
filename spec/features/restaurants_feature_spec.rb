require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end
  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  def user_login
    visit '/restaurants'
    click_link 'Sign up'
    fill_in 'Email', with: "tester@test.de"
    fill_in 'Password', with: "testtest"
    fill_in 'Password confirmation', with: "testtest"
    click_button 'Sign up'
  end


  context 'creating restaurants' do
    before {user_login}
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    scenario "doesn't accept a new restaurant if the user isn't logged in" do
      visit('/')
      click_link 'Sign out'
      click_link 'Add a restaurant'
      expect(page).to have_content "You need to sign in or sign up before continuing"
    end

    context "an invalid restaurant" do
      it 'does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){Restaurant.create(name:'KFC')}
    scenario 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'KFC'
     expect(page).to have_content 'KFC'
     expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before {user_login}
    before {Restaurant.create name: 'KFC'}
    scenario 'let a user edit a restaurant' do
     visit '/restaurants'
     click_link 'Edit KFC'
     fill_in 'Name', with: 'Kentucky Fried Chicken'
     click_button 'Update Restaurant'
     expect(page).to have_content 'Kentucky Fried Chicken'
     expect(current_path).to eq '/restaurants'
    end
  end

  context 'deleting restaurants' do
    before {user_login}
    before {Restaurant.create name: 'KFC'}
    before {Restaurant.find_by(name: 'KFC').reviews.create(thoughts: "Oh my god")}

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'removes all reviews when a user deletes the restaurant' do
      visit '/restaurants'
      click_link "Delete KFC"
      expect(page).not_to have_content 'KFC'
      expect(page).not_to have_content 'Oh my god'
    end
  end


end