require 'rails_helper'

RSpec.describe Shift, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:work_role) }
  it { is_expected.to validate_presence_of :shift_in_at }
  it { is_expected.to validate_presence_of :shift_out_at }
end
