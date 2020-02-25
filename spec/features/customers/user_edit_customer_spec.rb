require 'rails_helper'

feature 'User edit customer' do
  scenario 'successfully' do
    # Arrange
    user = create(:user, email: 'tst@tst.com')
    customer = create(:customer, user: user)
    login_as(user, scope: :user)
    visit root_path
    # Act
    click_on 'Clientes'
    within("tr#customer-#{customer.id}") do
      find("a[href='#{edit_customer_path(customer)}']").click
    end
    fill_in 'Nome', with: 'George R R Martin'
    click_on 'Salvar'
    # Assert
    expect(page).not_to have_content(customer.name)
    expect(page).to have_content('George R R Martin')
    expect(page).to have_content(customer.email)
    expect(page).to have_content(customer.phone)
  end

  scenario 'failed' do
    # Arrange
    user = create(:user, email: 'tst@tst.com')
    customer = create(:customer, user: user)
    login_as(user, scope: :user)
    # Act
    visit customers_path
    within("tr#customer-#{customer.id}") do
      find("a[href='#{edit_customer_path(customer)}']").click
    end
    fill_in 'Nome', with: ''
    click_on 'Salvar'
    # Assert
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Endereço')
    expect(page).to have_content('CPF')
    expect(page).to have_content('E-mail')
  end
end
