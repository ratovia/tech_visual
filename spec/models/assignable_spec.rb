require 'rails_helper'

RSpec.describe Assignable, type: :model do
  it {
    # ユニーク制約の検証にはあらかじめ有効なレコードが1件必要
    create(:assignable)
    is_expected.to validate_uniqueness_of(:user_id).scoped_to(:work_role_id)
  }
end
