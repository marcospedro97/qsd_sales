require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe '.burn' do
    it 'burn a used coupon' do
      coupon = Coupon.new(name: 'NATLOCA01')
      url = "http://localhost:4000/api/v1/coupon/#{coupon.name}/burn"
      json_file = File.read(
        Rails.root.join('spec/support/jsons/burn_coupon.json')
      )
      double_response = double('faraday_response', body: json_file,
                                                   status: 200)
      allow(Faraday).to receive(:get).with(url).and_return(double_response)

      result = Coupon.burn(coupon.name)

      expect(result).to eq 'burned'
    end

    it 'return 404 if coupon doesnt exists' do
      coupon = Coupon.new(name: 'NATLOCA01')
      url = "http://localhost:4000/api/v1/coupon/#{coupon.name}/burn"
      json_file = File.read(
        Rails.root.join('spec/support/jsons/burn_coupon.json')
      )
      double_response = double('faraday_response', body: json_file,
                                                   status: 404)
      allow(Faraday).to receive(:get).with(url).and_return(double_response)

      result = Coupon.burn(coupon.name)

      expect(result).to eq []
    end
  end
end
