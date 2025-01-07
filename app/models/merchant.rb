class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  def self.merchants_by_age()
    return Merchant.order(created_at: 'desc')
  end
end