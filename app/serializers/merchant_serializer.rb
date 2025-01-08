class MerchantSerializer
  def self.format_merchant(merchant)
    {
      id: merchant.id.to_s,
      type: "merchant",
      attributes: {
        name: merchant.name
      }
    }
  end

  def self.format_merchant_json(merchant)
    { data:
      format_merchant(merchant)
    }
  end

  def self.format_merchants_json(merchants)
    { data:
    merchants.map do |merchant|
      format_merchant(merchant)
      end
    }
  end

  def self.format_merchants_count_json(merchants)
    { data:
    merchants.map do |merchant|
      {
      id: merchant.id.to_s,
      type: "merchant",
      attributes: {
        name: merchant.name,
        item_count: merchant.items.count
      }}
    end
    }
  end
end