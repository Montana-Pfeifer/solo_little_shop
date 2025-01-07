class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :unit_price, presence: true, numerically: {only_float: true}
  validates :merchnat_id, presence: true, numerically: {only_integer: true}
end