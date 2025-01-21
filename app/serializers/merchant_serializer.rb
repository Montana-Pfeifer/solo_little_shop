class MerchantSerializer
  def self.format_merchant_object(merchant)
    {
      id: merchant.id.to_s,
      type: "merchant",
      attributes: {
        name: merchant.name,
        coupon_count: merchant.coupons.count,
        invoice_count: merchant.invoices.where.not(coupon_id: nil).distinct.count

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
            item_count: merchant.items.count,
            coupon_count: merchant.coupons.count,
            invoice_with_coupon_count: merchant.invoices.where.not(coupon_id: nil).count
          }
        }
      end
    }
  end
end
