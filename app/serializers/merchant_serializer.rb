class MerchantSerializer
  def self.format_merchant(merchant)
    {
      id: merchant.id,
      type: "merchant",
      attributes: {
        name: merchant.name
      }
    }
  end

  def self.format_merchants_json(merchants)
    { data:
      merchants.map do |merchant|
        format_merchant(merchant)
      end
    }
  end

  def self.format_merchant_json(merchant)
    { data:
      format_merchant(merchant)
    }
  end
end