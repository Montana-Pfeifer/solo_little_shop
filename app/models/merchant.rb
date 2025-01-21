class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items, dependent: :destroy
  has_many :coupons, dependent: :destroy

  validates :name, presence: true

  def self.merchants_by_age()
    Merchant.order(created_at: 'desc')
  end

  def self.merchants_with_returns
    joins(:invoices).where(invoices: { status: 'returned' }).distinct
  end

  def self.fetch_all_items(merchant_data)
    Item.where(merchant_id: merchant_data.id)
  end

  def self.find_by_name(name)
    where('name ILIKE ?', "%#{name}%")
  end

  def has_reached_coupon_limit?
    coupons.count >= 5
  end

end