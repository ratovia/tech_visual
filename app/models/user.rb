class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # enums
  enum role: { admin: 1, member: 2 }

  # associations
  has_many :check_boxes

  # validates
  validates :name, :role, presence: true
end
