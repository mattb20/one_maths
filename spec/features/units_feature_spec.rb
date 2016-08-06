require 'rails_helper'

feature 'courses' do
  def sign_up_tester
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'tester@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
  end

  context 'A course with no units' do
    let!(:maker){Maker.create(email: 'maker@maker.com', password: '12344321',
      password_confirmation: '12344321')}
    let!(:science){ maker.courses.create(name:'Science',
      description:'Super fun!')}

    scenario 'should display a prompt to add a unit' do
      visit '/courses'
      click_link 'Sign in'
      fill_in 'Email', with: 'maker@maker.com'
      fill_in 'Password', with: '12344321'
      click_button 'Log in'
      expect(page).to have_content 'No units have been added for Science'
      expect(page).to have_link 'Add a unit for Science'
    end
  end
end
