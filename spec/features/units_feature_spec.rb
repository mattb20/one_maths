require 'rails_helper'

def sign_up_tester
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: 'tester@example.com')
  fill_in('Password', with: 'testtest')
  fill_in('Password confirmation', with: 'testtest')
  click_button('Sign up')
  visit "/courses"
end

def sign_in_maker
  visit '/'
  click_link 'Sign in'
  fill_in 'Email', with: 'maker@maker.com'
  fill_in 'Password', with: '12344321'
  click_button 'Log in'
  visit '/'
end

def create_maker
  maker = Maker.create(email: 'maker@maker.com', password: '12344321',
    password_confirmation: '12344321')
end

def create_course(maker)
  maker.courses.create(name:'Science',description:'Super fun!')
end

def create_unit(course,maker)
  course.units.create_with_maker({name:'Core 1', description:'Basic maths'},maker)
end

feature 'units' do
  context 'A course with no units' do
    scenario 'should display a prompt to add a unit' do
      maker = create_maker
      create_course(maker)
      sign_in_maker
      expect(current_path).to eq '/'
      expect(page).to have_content 'No units have been added for Science'
      expect(page).to have_link 'Add a unit for Science'
    end
  end

  context 'units have been added' do
    scenario 'display course' do
      maker = create_maker
      course = create_course(maker)
      create_unit(course,maker)
      visit "/courses"
      expect(page).to have_content('Core 1')
      expect(page).to have_content('Basic maths')
    end
  end

  context 'adding units to a course' do
    let!(:maker){create_maker}
    let!(:science){create_course(maker)}

    scenario 'when not logged in cannot add unit' do
      visit "/courses/#{science.id}/units/new"
      expect(page).not_to have_link "Add an unit"
    end

    scenario 'a maker adding a unit to his course' do
      sign_in_maker
      click_link 'Add a unit for Science'
      fill_in 'Name', with: 'Core 1'
      fill_in 'Description', with: 'Very simple maths'
      click_button 'Create Unit'
      expect(page).to have_content 'Core 1'
      expect(page).to have_content 'Very simple maths'
      expect(current_path).to eq '/courses'
    end

    scenario 'a different maker cannot add a unit' do
      sign_up_tester
      visit "/courses/#{science.id}/units/new"
      expect(page).not_to have_link "Add a unit for Science"
      expect(page).to have_content 'You can only add units to your own course'
    end
  end

  context 'viewing units in a course' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:core_1){create_unit(course,maker)}

    scenario 'public can view units in a course' do
      visit "/courses"
      click_link 'View Core 1'
      expect(page).to have_content 'Core 1'
      expect(page).to have_content 'Basic maths'
      expect(current_path).to eq "/units/#{core_1.id}"
    end
  end

  context 'updating units in a course' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:core_1){create_unit(course,maker)}

    scenario 'a maker can update his own units' do
      sign_in_maker
      click_link 'Edit Core 1'
      fill_in 'Name', with: 'Mechanics 1'
      fill_in 'Description', with: 'Basic physics'
      click_button 'Update Unit'
      expect(page).to have_content 'Mechanics 1'
      expect(page).to have_content 'Basic physics'
      expect(current_path).to eq '/courses'
    end

    scenario "a maker cannot edit someone else's units" do
      sign_up_tester
      visit "/units/#{core_1.id}/edit"
      expect(page).not_to have_link 'Edit Core 1'
      expect(page).to have_content 'You can only edit your own units'
      expect(current_path).to eq "/courses"
    end
  end

  context 'deleting units in a course' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:core_1){create_unit(course,maker)}

    scenario 'a maker can delete their own unit' do
      sign_in_maker
      click_link 'Delete Core 1'
      expect(page).not_to have_content "Core 1"
      expect(page).not_to have_content "Basic maths"
      expect(current_path).to eq "/"
    end

    scenario "a maker cannot delete another maker's units" do
      sign_up_tester
      page.driver.submit :delete, "/units/#{core_1.id}",{}
      expect(page).not_to have_link 'Delete Core 1'
      expect(page).to have_content 'Can only delete your own units'
    end

  end
end



# <%= f.submit 'Leave Review' %>
