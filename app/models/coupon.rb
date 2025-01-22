class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices, dependent: :destroy

  validates :name, :code, :discount_type, :value, presence: true
  validates :code, uniqueness: { scope: :merchant_id, message: "has already been taken for this merchant" }
  validate :merchant_cannot_have_more_than_five_coupons, on: :create
  
  scope :active, -> { where(status: true) }
  scope :inactive, -> { where(status: false) }

  
  private

  def merchant_cannot_have_more_than_five_coupons
    if merchant.coupons.count >= 5
      errors.add(:base, "Merchant cannot have more than five coupons.")
    end
  end

  def self.filter_by_status(merchant, status)
    case status
    when 'active'
      merchant.coupons.where(status: true)
    when 'inactive'
      merchant.coupons.where(status: false)
    else
      nil
    end
  end

end
