class Product
  attr_accessor :name, :id

  def initialize(id, name)
    @name = name
    @id = id
  end

  def self.api_version
    'v1'
  end

  def self.endpoint
    Rails.configuration.qsd_apis[:product_url]
  end

  def self.product_url
    "#{endpoint}/api/#{api_version}"
  end

  def self.all
    request_url = "#{product_url}/product_types"
    response = Faraday.get(request_url)

    return [] if response.status == 500 || response.status == 404

    json = JSON.parse(response.body, symbolize_names: true)

    result = []
    json.each do |item|
      result << Product.new(item[:id], item[:name])
    end

    result
  end

  def self.find(product_id)
    @product = all.detect { |product| product.id == product_id }
  end
end
