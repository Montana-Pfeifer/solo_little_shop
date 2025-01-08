class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :name, presence: true
  
  def self.merchants_by_age()
      return Merchant.order(created_at: 'desc')
  end

  def self.merchants_with_returns(all_merchants)
    merchants_with_returns = []
    all_merchants.each do |merchant|
      merchant.invoices.each do |invoice|
        if invoice.status == 'returned'
          merchants_with_returns.push(merchant)
        end
      end
    end
    return merchants_with_returns
  end
end