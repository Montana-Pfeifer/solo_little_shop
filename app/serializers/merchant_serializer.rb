class MerchantSerializer
  def self.format_merchant_object(merchant)
    {
      id: merchant.id.to_s,
      type: "merchant",
      attributes: {
        name: merchant.name
      }
    }
  end

  def self.format_merchant(merchant)
    { data:
      format_merchant_object(merchant)
    }
  end

  def self.format_merchants(merchants)
    { data:
    merchants.map do |merchant|
      format_merchant_object(merchant)
      end
    }
  end

  def self.format_merchants_count(merchants)
    { data:
    merchants.map do |merchant|
      {
      id: merchant.id.to_s,
      type: "merchant",
      attributes: {
        name: merchant.name,
        item_count: merchant.items.count
      }
    }
    end
    }
  end
end