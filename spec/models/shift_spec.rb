require 'rails_helper'

RSpec.describe Shift, type: :model do
  describe 'validation' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:work_role) }
    it { is_expected.to validate_presence_of :shift_in_at }
    it { is_expected.to validate_presence_of :shift_out_at }
  end

  describe 'methods' do
    context 'self.build_from_genoms' do
      let(:user) { create(:user) }
      let(:work_roles) { create_list(:work_role, 4) }
      let(:genoms) {{
        this_day: "Wed, 01 Jan 2020 00:00:00 +0000",
        shifts: [
          user_id: user.id,
          array: [nil, nil, nil, nil, nil, nil, 3, 2, 2, 2, 1, 2, 4, 0, 1, 1, nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      }}

      it '想定しているシフトの件数(6件)と一致している' do
        shifts = Shift.build_from_genoms(genoms)
        expect(shifts.length).to eq 6
      end

      it '最初のシフトが想定通りの値になっている' do
        shifts = Shift.build_from_genoms(genoms)
        valid_shift_attributes = Shift.new(
          user_id: user.id,
          work_role_id: 3,
          shift_in_at: DateTime.new(2020, 1, 1, 6),
          shift_out_at: DateTime.new(2020, 1, 1, 7)
        ).attributes
        expect(shifts[0].attributes).to eq valid_shift_attributes
      end

      it '2番目のシフトが想定通りの値になっている' do
        shifts = Shift.build_from_genoms(genoms)
        valid_shift_attributes = Shift.new(
          user_id: user.id,
          work_role_id: 2,
          shift_in_at: DateTime.new(2020, 1, 1, 7),
          shift_out_at: DateTime.new(2020, 1, 1, 10)
        ).attributes
        expect(shifts[1].attributes).to eq valid_shift_attributes
      end

      it '最後のシフトが想定通りの値になっている' do
        shifts = Shift.build_from_genoms(genoms)
        valid_shift_attributes = Shift.new(
          user_id: user.id,
          work_role_id: 1,
          shift_in_at: DateTime.new(2020, 1, 1, 14),
          shift_out_at: DateTime.new(2020, 1, 1, 16)
        ).attributes
        expect(shifts[-1].attributes).to eq valid_shift_attributes
      end

    end
  end
end
