require 'rails_helper'

RSpec.describe RequiredResource, type: :model do
  it { is_expected.to belong_to(:work_role) }
  it { is_expected.to define_enum_for(:what_day) }
  it { is_expected.to validate_presence_of :clock_at }
  it { is_expected.to validate_presence_of :count }
end
