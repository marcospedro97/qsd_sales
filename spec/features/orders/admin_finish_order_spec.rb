require 'rails_helper'

feature 'User finish order' do
  scenario 'successfully' do
    user = create(:user, role: 5)
    customer = create(:customer, user: user)
    order = create(:order, user: user, customer: customer)
    products = [Product.new(1, 'Hospedagem'), Product.new(2, 'CLOUD')]
    allow(Product).to receive(:all).and_return(products)
    plans = [Plan.new(1, 'Linux'), Plan.new(2, 'Windows')]
    allow(Plan).to receive(:all).and_return(plans)
    prices = [Price.new(1, 100, 1, 'Mensal')]
    allow(Price).to receive(:find_by).and_return(prices)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Pedidos'
    within("tr#order-#{order.id}") do
      find("a[href='#{order_path(order)}'][data-method='get']").click
    end
    click_on 'Aprovar'

    expect(page).to have_content('Pedido aprovado com sucesso')
    expect(page).to have_content(order.code)
    expect(page).to have_content('Status: Aprovado')
    expect(page).not_to have_link('Aprovar')
  end

  scenario 'and status need to be open' do
    user = create(:user)
    customer = create(:customer, user: user)
    order = create(:order, status: 4, user: user, customer: customer)
    products = [Product.new(1, 'Hospedagem'), Product.new(2, 'CLOUD')]
    allow(Product).to receive(:all).and_return(products)
    plans = [Plan.new(1, 'Linux'), Plan.new(2, 'Windows')]
    allow(Plan).to receive(:all).and_return(plans)
    prices = [Price.new(1, 100, 1, 'Mensal')]
    allow(Price).to receive(:find_by).and_return(prices)

    login_as(user, scope: :user)
    visit order_path(order)
    click_on 'Pedidos'
    within("tr#order-#{order.id}") do
      find("a[href='#{order_path(order)}'][data-method='get']").click
    end

    expect(page).to_not have_button('Aprovar')
  end
end
