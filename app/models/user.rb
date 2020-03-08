class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # enums
  enum role: { admin: 1, employee: 2, part_timer: 3 }

  # associations
  has_many :attendances
  has_many :shifts
  has_many :assignables
  has_many :work_roles, through: :assignables

  # validates
  validates :name, :role, presence: true
  validates :name, uniqueness: true

  class << self
    def build_user_genom(genom_params)
      user = find(genom_params[:user_id])
      shift_array = genom_params[:shift_array].map do |ele|
        if ele == ''
          nil
        elsif WorkRole.ids.include?(ele.to_i)
          ele.to_i
        else
          0
        end
      end
      { user_id: user.id, user_name: user.name, array: shift_array }
    end
  end
end
