class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_customer, only: %i[show edit update destroy]
  before_action :customer_belongs_to_another, only: %i[search]

  def index
    @customers = Customer.all
  end

  def search
    (redirect_to new_customer_path) && return if @customers.empty? && params[:q]
    if customer_belongs_to_another
      flash[:alert] = 'Este cliente pertence a outro vendedor'
    end
    render :index
  end

  def show; end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    @customer.user = current_user
    if @customer.save
      redirect_to @customer, notice: t('.success')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_path
  end

  private

  def customer_belongs_to_another
    @customers = Customer.where('document LIKE ?', "%#{params[:q]}%")
    @customers.count == 1 && @customers.first.user != current_user \
    && !current_user.admin?
  end

  def customer_params
    params.require(:customer).permit(:name, :address, :document, :email,
                                     :phone, :birth_date)
  end

  def find_customer
    @customer = Customer.find(params[:id])
  end
end
