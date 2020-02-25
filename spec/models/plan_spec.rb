require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe '.all' do
    it 'should get all plans via API' do
      url = 'http://localhost:3000/api/v1/plans'
      json_file = File.read(
        Rails.root.join('spec/support/jsons/plan_index.json')
      )
      double_response = double('faraday_response', body: json_file,
                                                   status: 200)

      allow(Faraday).to receive(:get).with(url).and_return(double_response)
      allow_any_instance_of(Faraday)

      result = Plan.all

      expect(result.length).to eq 3
      expect(result[0].name).to eq 'Linux'
      expect(result[1].name).to eq 'Windows'
      expect(result[2].name).to eq 'TESTHOSPTEST41 LITE'
    end

    it 'should return an empty array if API return error' do
      url = 'http://localhost:3000/api/v1/plans'
      double_response = double('faraday_response', status: 500)

      allow(Faraday).to receive(:get).with(url).and_return(double_response)

      result = Plan.all

      expect(result.length).to eq 0
    end
  end

  describe '.find' do
    it 'find plan for id' do
      plan = Plan.new(1, 'Linux')
      url = 'http://localhost:3000/api/v1/plans'
      json_file = File.read(
        Rails.root.join('spec/support/jsons/plan_index.json')
      )
      double_response = double('faraday_response', body: json_file,
                                                   status: 200)

      allow(Faraday).to receive(:get).with(url).and_return(double_response)

      result = Plan.find(plan.id)

      expect(plan.id == result.id).to eq(true)
    end

    it 'find not return result' do
      url = 'http://localhost:3000/api/v1/plans'

      double_response = double('faraday_response', status: 500)

      allow(Faraday).to receive(:get).with(url).and_return(double_response)

      result = Plan.find(1)

      expect(result.nil?).to be_truthy
    end
  end
end
