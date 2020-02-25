require 'rails_helper'

feature 'User edit any order' do
  scenario 'Sucessfully' do
    prices = [Price.new(1, 100, 1, 'Mensal')]
    allow(Price).to receive(:all).and_return(prices)
    allow(Price).to receive(:find).and_return(prices[0])
    user = create(:user, email: 'xaviervi@hotmail.com')
    customer = create(:customer, user: user)
    order = create(:order, user: user, customer: customer)
    products = [Product.new(1, 'Hospedagem'), Product.new(2, 'CLOUD')]
    allow(Product).to receive(:all).and_return(products)
    plans = [Plan.new(1, 'Linux'), Plan.new(2, 'Windows')]
    allow(Plan).to receive(:all).and_return(plans)

    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    within("tr#order-#{order.id}") do
      find("a[href='#{order_path(order)}'][data-method='get']").click
    end
    click_on 'Editar'

    select 'Hospedagem', from: 'Produto'
    select 'Windows', from: 'Plano'
    select prices[0].expose.to_s, from: 'Preço'
    click_on 'Efetivar'

    expect(page).to have_content(order.user.id)
    expect(page).to have_content(order.customer.name)
    expect(page).to have_content(order.customer.document)
    expect(page).to have_content('Hospedagem')
    expect(page).to have_content('Windows')
    expect(page).to have_content(prices[0].expose.to_s)
  end

  scenario 'by index' do
    prices = [Price.new(1, 100, 1, 'Mensal')]
    allow(Price).to receive(:all).and_return(prices)
    allow(Price).to receive(:find).and_return(prices[0])
    user = create(:user, email: 'xaviervi@hotmail.com')
    customer = create(:customer, user: user)
    order = create(:order, customer: customer, user: user)
    products = [Product.new(1, 'Hospedagem'), Product.new(2, 'CLOUD')]
    allow(Product).to receive(:all).and_return(products)
    plans = [Plan.new(1, 'Linux'), Plan.new(2, 'Windows')]
    allow(Plan).to receive(:all).and_return(plans)

    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    within("tr#order-#{order.id}") do
      find("a[href='#{edit_order_path(order)}']").click
    end

    select 'Hospedagem', from: 'Produto'
    select 'Windows', from: 'Plano'
    select prices[0].expose, from: 'Preço'
    click_on 'Efetivar'

    expect(page).to have_content(order.user.id)
    expect(page).to have_content(order.customer.name)
    expect(page).to have_content(order.customer.document)
    expect(page).to have_content('Hospedagem')
    expect(page).to have_content('Windows')
    expect(page).to have_content(prices[0].expose)
  end
end
