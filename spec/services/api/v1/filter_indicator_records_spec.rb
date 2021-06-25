require 'rails_helper'

RSpec.describe API::V1::FilterIndicatorRecords do
  let(:indicator) { create(:indicator) }
  let!(:record1) { create(:record, indicator: indicator, category_1: 'xxx', year: 2020) }
  let!(:record2) { create(:record, indicator: indicator, category_1: 'yyy', year: 2021) }

  context 'when no filter' do
    it 'returns all records' do
      filter = API::V1::FilterIndicatorRecords.new(indicator.id)

      expect(filter.call).to match_array([record1, record2])
    end
  end

  context 'when filtering by category_1' do
    it 'returns matching records' do
      filter = API::V1::FilterIndicatorRecords.new(indicator.id, category_1: 'xxx')

      expect(filter.call).to match_array([record1])
    end
  end

  context 'when filtering by year range' do
    it 'returns matching records' do
      filter = API::V1::FilterIndicatorRecords.new(indicator.id, start_year: 2021)

      expect(filter.call).to match_array([record2])
    end
  end
end
