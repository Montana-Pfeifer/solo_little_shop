class Coupon < ApplicationRecord
  belongs_to :merchant
  
  validates :name, :code, :discount_type, :value, presence: true
  validates :code, uniqueness: true
end
