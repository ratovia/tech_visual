require 'rails_helper'

RSpec.describe Attendance, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :attendance_at }
  it { is_expected.to validate_presence_of :leaving_at }
end
