class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_costumer_order_product, only: %i[create]
  before_action :find_customer, only: %i[new create]
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
    @product = Product.find(@order.product_id)
    @plan = Plan.find(@order.plan_id)
    @price = Price.find(plan_id: @order.plan_id, price_id: @order.price_id)
  end

  def new
    @order = Order.new
    load_customers_and_products
  end

  def create
    @order.code = SecureRandom.hex(6)
    @order.user = current_user
    @price = Price.find(plan_id: @order.plan_id, price_id: @order.price_id)
    @order.final_price = select_price
    return redirect_to @order, notice: t('.success') if @order.save

    load_customers_and_products
    render :new
  end

  def edit
    @order = Order.find(params[:id])
    load_customers_and_products
  end

  def update
    @order = Order.find(params[:id])
    @order.coupon_name = order_params[:coupon_name]
    @price = Price.find(plan_id: @order.plan_id, price_id: @order.price_id)
    @order.final_price = select_price
    @order.update(order_params)
    redirect_to @order
  end

  def cancel
    @order = Order.find(params[:id])
  end

  def finish_cancel
    @order = Order.find(params[:id])
    @order.status = :cancelled
    return render :cancel unless @order.update(order_params)

    redirect_to order_path(@order), notice: t('.success')
  end

  def approve
    @order = Order.find(params[:id])
    Coupon.burn(@order.coupon_name) if @order.coupon_name.present?
    @order.approved!
    redirect_to @order, notice: t('.success')
  end

  private

  def order_params
    params.require(:order).permit(:product_id, :plan_id,
                                  :price_id, :cancellation_reason,
                                  :coupon_name)
  end

  def load_customers_and_products
    @customers = Customer.all
    @products = Product.all
    @plans = Plan.all
    @prices = Price.all(@plans)
  end

  def set_costumer_order_product
    @customer = Customer.find(params[:customer_id])
    @order = @customer.orders.new(order_params)
    @product = Product.find(@order.product_id)
  end

  def select_price
    return @price.plan_price if order_params[:coupon_name].blank?

    result = @price.discount(@order.coupon_name, @order.product_id)
    return @price.plan_price if result.is_a?(String)

    result
  end

  def find_customer
    @customer = Customer.find(params[:customer_id])
  end
end
