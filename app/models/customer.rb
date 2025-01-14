class Customer < ApplicationRecord
  has_many :invoices

  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.fetch_customers_per_merchant(merchant)
    joins(:invoices).where(invoices: { merchant_id: merchant.id }).distinct
  end
end