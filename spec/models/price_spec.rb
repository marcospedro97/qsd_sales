require 'rails_helper'

RSpec.describe Price, type: :model do
  describe '.all' do
    it 'should get all prices of a set of plans' do
      url = 'http://localhost:3000/api/v1/plans/1/prices'
      other_url = 'http://localhost:3000/api/v1/plans/2/prices'

      json_file = File.read(
        Rails.root.join('spec/support/jsons/price_index.json')
      )
      double_response = double('faraday_response', body: json_file,
                                                   status: 200)
      allow(Faraday).to receive(:get).with(url).and_return(double_response)
      allow(Faraday).to receive(:get).with(other_url)
                                     .and_return(double_response)

      plans = [Plan.new(1, 'Linux'), Plan.new(2, 'Windows')]

      result = Price.all(plans)

      expect(result.length).to eq 6
      expect(result[0].expose).to eq 'CincoAnos - R$ 4.356,87'
      expect(result[1].expose).to eq 'SeisAnos - R$ 5.351,09'
      expect(result[2].expose).to eq 'SeteAnos - R$ 6.129,13'
      expect(result[3].expose).to eq 'CincoAnos - R$ 4.356,87'
      expect(result[4].expose).to eq 'SeisAnos - R$ 5.351,09'
      expect(result[5].expose).to eq 'SeteAnos - R$ 6.129,13'
    end

    it 'should return an empty array if API return error' do
      url = 'http://localhost:3000/api/v1/plans/1/prices'
      double_response = double('faraday_response', status: 500)
      allow(Faraday).to receive(:get).with(url).and_return(double_response)
      plans = [Plan.new(1, 'Linux')]

      result = Price.all(plans)

      expect(result.length).to eq 0
    end
  end

  describe '.find_by' do
    it 'should get all prices of a given plan' do
      url = 'http://localhost:3000/api/v1/plans/1/prices'
      json_file = File.read(
        Rails.root.join('spec/support/jsons/price_index.json')
      )
      double_response = double('faraday_response', body: json_file,
                                                   status: 200)
      allow(Faraday).to receive(:get).with(url).and_return(double_response)

      result = Price.find_by(plan_id: 1)

      expect(result.length).to eq 3
      expect(result[0].expose).to eq 'CincoAnos - R$ 4.356,87'
      expect(result[1].expose).to eq 'SeisAnos - R$ 5.351,09'
      expect(result[2].expose).to eq 'SeteAnos - R$ 6.129,13'
    end

    it 'should return an empty array if API return error' do
      url = 'http://localhost:3000/api/v1/plans/1/prices'
      double_response = double('faraday_response', status: 500)

      allow(Faraday).to receive(:get).with(url).and_return(double_response)

      result = Price.find_by(plan_id: 1)

      expect(result.length).to eq 0
    end
  end

  describe '.find' do
    it 'price successfully' do
      url = 'http://localhost:3000/api/v1/plans/1/prices'
      json_file = File.read(
        Rails.root.join('spec/support/jsons/price_index.json')
      )
      double_response = double('faraday_response', body: json_file,
                                                   status: 200)

      allow(Faraday).to receive(:get).with(url).and_return(double_response)

      result = Price.find(plan_id: 1, price_id: 1)

      expect(result.expose).to eq('CincoAnos - R$ 4.356,87')
    end

    it 'and get no result' do
      url = 'http://localhost:3000/api/v1/plans/1/prices'
      double_response = double('faraday_response', status: 500)
      allow(Faraday).to receive(:get).with(url).and_return(double_response)

      result = Price.find(plan_id: 1, price_id: 1)

      expect(result.nil?).to be_truthy
    end
  end
end
