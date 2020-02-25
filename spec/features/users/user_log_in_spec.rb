require 'rails_helper'

feature 'User log in' do
  scenario 'from home page' do
    user = create(:user)
    visit root_path
    click_on 'Entrar'

    within 'form' do
      fill_in 'E-mail', with: 'douglas@gmail.com'
      fill_in 'Senha', with: '12345678'
      click_on 'Entrar'
    end

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Login efetuado com sucesso.')
    expect(page).to have_content('Sair')
    expect(page).to_not have_content('Entrar')
    expect(page).to have_content("Logado como: #{user.email}")
  end

  scenario 'user log out' do
    user = create(:user)
    login_as(user, scope: :user)
    visit root_path

    click_on 'Sair'

    expect(current_path).to eq(new_user_session_path)
  end
end
