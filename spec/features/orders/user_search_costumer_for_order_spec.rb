require 'rails_helper'

feature 'User search costumer for order' do
  scenario 'sucessfully' do
    # Arrange
    Price.new(1, 100, 1, 'Mensal')
    user = create(:user)
    customer = create(:customer, user: user)
    products = [Product.new(1, 'Hospedagem'), Product.new(2, 'CLOUD')]
    allow(Product).to receive(:all).and_return(products)
    plans = [Plan.new(1, 'Linux'), Plan.new(2, 'Windows')]
    allow(Plan).to receive(:all).and_return(plans)

    # Act
    login_as user, scope: :user
    visit root_path
    click_on 'Clientes'
    fill_in 'Pesquisar', with: customer.document
    click_on 'Buscar'

    # Assert
    expect(page).to have_content(customer.name)
    expect(page).to have_content(customer.email)
  end

  scenario 'Customer does not exit, create a new one' do
    user = create(:user, email: 'tst@tst.com')

    login_as user, scope: :user
    visit root_path
    click_on 'Clientes'
    fill_in 'Pesquisar', with: '999.999.999-99'
    click_on 'Buscar'

    expect(current_path).to eq new_customer_path
  end

  scenario 'Seller cannot see customer from another seller ' do
    user = create(:user)
    other_user = create(:user, email: 'tst@tst.com')
    customer = create(:customer, user: user)

    login_as other_user, scope: :user
    visit root_path
    click_on 'Clientes'
    fill_in 'Pesquisar', with: customer.document
    click_on 'Buscar'

    expect(page).to have_content('Este cliente pertence a outro vendedor')
  end
end
