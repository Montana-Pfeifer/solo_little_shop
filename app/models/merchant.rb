class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :name, presence: true

  def self.merchants_by_age()
      return Merchant.order(created_at: 'desc')
  end

  def self.merchants_with_returns
    joins(:invoices).where(invoices: { status: 'returned' }).distinct
  end
end