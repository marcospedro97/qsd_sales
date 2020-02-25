class Coupon
  attr_reader :name, :discount, :status
  def initialize(name: '', discount: 0, status: '')
    @name = name
    @discount = discount
    @status = status
  end

  def self.api_version
    'v1'
  end

  def self.endpoint
    Rails.configuration.qsd_apis[:coupon_url]
  end

  def self.coupon_url
    "#{endpoint}/api/#{api_version}"
  end

  def self.burn(code)
    request_url = "#{coupon_url}/coupon/#{code}/burn"
    response = Faraday.get(request_url)
    return [] if response.status == 404

    json = JSON.parse(response.body, symbolize_names: true)

    @status = json[:status]
  end
end
