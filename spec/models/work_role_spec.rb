require 'rails_helper'

RSpec.describe WorkRole, type: :model do
  it { is_expected.to have_many(:required_resources) }
  it { is_expected.to have_many(:shifts) }
  it { is_expected.to validate_presence_of :name }
end
