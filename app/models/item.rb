class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: {only_float: true}
  validates :merchant_id, presence: true, numericality: {only_integer: true}

  def self.find_by_name(name)
    where('name ILIKE ?', "%#{name}%")
  end

  def self.find_by_price(params)
    if params[:min_price] && params[:max_price]
      where('unit_price >= ? AND unit_price <= ?', params[:min_price], params[:max_price])
    elsif params[:min_price]
      where('unit_price >= ?', params[:min_price])
    elsif params[:max_price]
      where('unit_price <= ?', params[:max_price])
    else
      none
    end
  end
end
