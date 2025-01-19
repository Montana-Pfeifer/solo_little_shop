class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  belongs_to :coupon, optional: true
  
  has_many :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :customer_id, presence: true
  validates :merchant_id, presence: true
  validates :status, presence: true


  def self.find_all_invoices(merchant)
    Invoice.where(merchant_id: merchant.id)
  end

  def self.find_shipped_invoices(merchant)
    Invoice.where(merchant_id: merchant.id, status: 'shipped')
  end

  def self.find_returned_invoices(merchant)
    Invoice.where(merchant_id: merchant.id, status: 'returned')
  end

  def self.find_packaged_invoices(merchant)
    Invoice.where(merchant_id: merchant.id, status: 'packaged')
  end

end