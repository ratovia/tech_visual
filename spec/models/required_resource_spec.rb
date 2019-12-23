require 'rails_helper'

RSpec.describe RequiredResource, type: :model do
  describe 'validation' do
    it { is_expected.to belong_to(:work_role) }
    it { is_expected.to validate_presence_of :what_day }
    it { is_expected.to validate_numericality_of(:what_day)
      .is_greater_than_or_equal_to(1).is_less_than_or_equal_to(14) }
    it { is_expected.to validate_presence_of :clock_at }
    it { is_expected.to validate_numericality_of(:clock_at)
      .is_greater_than_or_equal_to(0).is_less_than_or_equal_to(23) }
    it { is_expected.to validate_presence_of :count }
  end

  describe 'methods' do
    context 'self.on_', on_: true do
      before(:all) { build(:work_role, :with_all_required_resources) }
      after(:all) { WorkRole.destroy_all }
      let(:default_counts) { 24 }

      it '第1キックオフ当日のレコードを正しく取得できる' do
        create(:required_resource, what_day: 1)
        test_records = RequiredResource.on_(Time.new(2019,12,7))
        expect(test_records).to eq 1
      end

      it '第1キックオフ翌日のレコードを正しく取得できる' do
        create(:required_resource, what_day: 2)
        test_records = RequiredResource.on_(Time.new(2019,12,8))
        expect(test_records).to eq 2
      end

      it '第1キックオフから7日目のレコードを正しく取得できる' do
        create(:required_resource, what_day: 7)
        test_records = RequiredResource.on_(Time.new(2019,12,13))
        expect(test_records).to eq 7
      end

      it '第1キックオフから8日目のレコードを正しく取得できる' do
        create(:required_resource, what_day: 8)
        test_records = RequiredResource.on_(Time.new(2019,12,14))
        expect(test_records).to eq 8
      end

      it '第1キックオフから14日目のレコードを正しく取得できる' do
        create(:required_resource, what_day: 14)
        test_records = RequiredResource.on_(Time.new(2019,12,20))
        expect(test_records).to eq 14
      end

      it '第2キックオフ当日のレコードを正しく取得できる' do
        create(:required_resource, what_day: 1)
        test_records = RequiredResource.on_(Time.new(2019,12,21))
        expect(test_records).to eq 1
      end

      it '第2キックオフ翌日のレコードを正しく取得できる' do
        create(:required_resource, what_day: 2)
        test_records = RequiredResource.on_(Time.new(2019,12,22))
        expect(test_records).to eq 2
      end
    end
  end
end
