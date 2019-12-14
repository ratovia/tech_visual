class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # enums
  enum role: { admin: 1, employee: 2, part_timer: 3 }

  # associations
  has_many :attendances
  has_many :check_boxes
  has_many :shifts

  # validates
  validates :name, :role, presence: true
end
