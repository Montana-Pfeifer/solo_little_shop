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
    scope = all
  
    if params[:min_price].present?
      min_price = params[:min_price].to_f
      scope = scope.where('unit_price >= ?', min_price)
    end
  
    if params[:max_price].present?
      max_price = params[:max_price].to_f
      scope = scope.where('unit_price <= ?', max_price)
    end
  
    scope
  end  
  
  def self.sort_by_price()
      Item.order(:unit_price)
  end

  def self.fetch_merchant(item)
    Merchant.find(item.merchant_id)
  end

end
