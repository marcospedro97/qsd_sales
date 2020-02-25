require 'rails_helper'

feature 'Admin view users' do
  scenario 'successfully' do
    user = create(:user, email: 'admin@teste.com', role: :admin)
    create(:user, email: 'teste@teste.com')
    create(:user, email: 'testando@testando.com')
    login_as(user, scope: :user)
    visit root_path

    click_on 'Usuários'

    expect(page).to have_content('admin@teste.com')
    expect(page).to have_content('teste@teste.com')
    expect(page).to have_content('testando@testando.com')
  end

  scenario 'Seller should not see users' do
    user = create(:user, email: 'testando@testando.com')
    login_as(user, scope: :user)
    visit users_path

    expect(current_path).to eq(root_path)
  end
end
