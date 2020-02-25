require 'rails_helper'

feature 'Admin change role' do
  scenario 'successfully' do
    user = create(:user, role: :admin)
    login_as(user, scope: :user)
    visit root_path

    click_on 'Usuários'
    first('.edit-button').click
    find('#user_role_admin').click
    click_on 'Update'

    expect(current_path).to eq(users_path)
  end
end
