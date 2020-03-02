require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:attendances) }
  it { is_expected.to have_many(:assignables) }
  it { is_expected.to have_many(:shifts) }
  it { is_expected.to define_enum_for(:role) }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :role }
end
