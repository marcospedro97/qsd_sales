require 'rails_helper'

feature 'User create order' do
  scenario 'Successfully' do
    user = create(:user)
    customer = create(:customer, user: user)
    login_as user, scope: :user
    products = [Product.new(1, 'Hospedagem'), Product.new(2, 'CLOUD')]
    allow(Product).to receive(:all).and_return(products)
    plans = [Plan.new(1, 'Linux'), Plan.new(2, 'Windows')]
    allow(Plan).to receive(:all).and_return(plans)
    prices = [Price.new(1, 100, 1, 'Mensal')]
    allow(Price).to receive(:all).and_return(prices)
    allow(Price).to receive(:find).and_return(prices[0])

    login_as user, scope: :user
    visit root_path
    click_on 'Clientes'
    click_on 'Novo Pedido'
    select 'Hospedagem', from: 'Produto'
    select 'Linux', from: 'Plano'
    select prices[0].expose, from: 'Preço'
    click_on 'Efetivar'

    expect(page).to have_content(user.id)
    expect(page).to have_content(customer.name)
    expect(page).to have_content(customer.document)
    expect(page).to have_content('Hospedagem')
    expect(page).to have_content('Linux')
    expect(page).to have_content(prices[0].expose)
  end

  scenario 'Failed' do
    user = create(:user)
    prices = [Price.new(1, 100, 1, 'Mensal')]
    allow(Price).to receive(:all).and_return(prices)
    allow(Price).to receive(:find).and_return(prices[0])
    create(:customer, user: user)
    products = [Product.new(1, 'Hospedagem'), Product.new(2, 'CLOUD')]
    allow(Product).to receive(:all).and_return(products)
    plans = [Plan.new(1, 'Linux'), Plan.new(2, 'Windows')]
    allow(Plan).to receive(:all).and_return(plans)

    login_as user, scope: :user
    visit root_path
    click_on 'Clientes'
    click_on 'Novo Pedido'
    select 'Hospedagem', from: 'Produto'
    click_on 'Efetivar'

    expect(page).to have_content('Preço não pode ficar em branco')
    expect(page).to have_content('Plano não pode ficar em branco')
  end
end
