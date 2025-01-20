require 'rails_helper'

class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  validates :name, :code, :discount_type, :value, presence: true
  validates :code, uniqueness: { scope: :merchant_id, message: "has already been taken for this merchant" }
  validate :merchant_cannot_have_more_than_five_coupons, on: :create

  private

  def merchant_cannot_have_more_than_five_coupons
    if merchant && merchant.has_reached_coupon_limit?
      errors.add(:merchant, "cannot have more than 5 coupons")
    end
  end
end
