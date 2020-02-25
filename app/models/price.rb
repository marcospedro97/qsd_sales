class Price
  include ActionView::Helpers::NumberHelper
  attr_accessor :id, :plan_price, :plan_id, :periodicity

  def initialize(id, plan_price, plan_id, periodicity)
    @id = id
    @plan_price = plan_price
    @plan_id = plan_id
    @periodicity = periodicity
  end

  def self.api_version
    'v1'
  end

  def self.endpoint
    Rails.configuration.qsd_apis[:product_url]
  end

  def self.coupon_endpoint
    Rails.configuration.qsd_apis[:coupon_url]
  end

  def self.coupon_url
    "#{coupon_endpoint}/api/#{api_version}"
  end

  def self.product_url
    "#{endpoint}/api/#{api_version}"
  end

  def self.all(plans)
    prices = []
    plans.each do |plan|
      prices += find_by(plan_id: plan.id)
    end
    prices
  end

  def self.find_by(plan_id:)
    request_url = "#{product_url}/plans/#{plan_id}/prices"
    response = Faraday.get(request_url)

    return [] if response.status == 500 || response.status == 404

    json = JSON.parse(response.body, symbolize_names: true)

    result = []
    json.each do |item|
      result << Price.new(item[:id], item[:plan_price],
                          item[:plan_id], item[:periodicity])
    end
    result
  end

  def self.find(plan_id:, price_id:)
    @price = find_by(
      plan_id: plan_id
    ).detect { |price| price.id == price_id }
  end

  def discount(coupon_name, product_id)
    request_url = "#{Price.coupon_url}/coupons/confer?coupon=#{coupon_name}" \
                  "&price=#{plan_price}&product=#{product_id}"
    response = Faraday.get(request_url)

    json = JSON.parse(response.body, symbolize_names: true)

    return json[:error] if response.status == 422 || response.status == 404

    @plan_price.to_f - json[:discount].to_f
  end

  def expose
    "#{periodicity} - #{number_to_currency(plan_price)}"
  end
end
