require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '.all' do
    it 'should get all products via API' do
      url = 'http://localhost:3000/api/v1/product_types'
      json_file = File.read(
        Rails.root.join('spec/support/jsons/product_index.json')
      )
      double_response = double('faraday_response', body: json_file,
                                                   status: 200)

      allow(Faraday).to receive(:get).with(url).and_return(double_response)
      allow_any_instance_of(Faraday)

      result = Product.all

      expect(result.length).to eq 3
      expect(result[0].name).to eq 'Hospedagem'
      expect(result[1].name).to eq 'Cloud'
      expect(result[2].name).to eq 'Email Marketing'
    end

    it 'should return an empty array if API return error' do
      url = 'http://localhost:3000/api/v1/product_types'
      double_response = double('faraday_response', status: 500)

      allow(Faraday).to receive(:get).with(url).and_return(double_response)

      result = Product.all

      expect(result.length).to eq 0
    end
  end

  describe '.find' do
    it 'find a Product Successfully' do
      url = 'http://localhost:3000/api/v1/product_types'
      json_file = File.read(
        Rails.root.join('spec/support/jsons/product_index.json')
      )
      double_response = double('faraday_response', body: json_file,
                                                   status: 200)

      allow(Faraday).to receive(:get).with(url).and_return(double_response)

      result = Product.find(1)

      expect(result.name).to eq('Hospedagem')
    end

    it 'find not return result' do
      url = 'http://localhost:3000/api/v1/product_types'

      double_response = double('faraday_response', status: 500)

      allow(Faraday).to receive(:get).with(url).and_return(double_response)

      result = Product.find(1)

      expect(result.nil?).to be_truthy
    end
  end
end
