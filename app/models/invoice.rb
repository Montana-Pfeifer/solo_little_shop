class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :customer_id, presence: true
  validates :merchant_id, presence: true
  validates :status, presence: true

end