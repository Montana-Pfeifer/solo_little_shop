class CouponSerializer

  def self.format_coupons(coupons)
    {  
      data:
      coupons.map do |coupon|
        {
          id: coupon.id.to_s,
          type: "coupon",
          attributes: {
            name: coupon.name,
            code: coupon.code,
            discount_type: coupon.discount_type,
            value: coupon.value,
            status: coupon.status,
            merchant: coupon.merchant_id.to_s,
            usage_count: coupon.invoices.count.to_s
          }
        }
      end
    }
  end

  def self.format_coupon(coupon)
    {
      data: {
        id: coupon.id.to_s,
        type: "coupon",
        attributes: {
          name: coupon.name,
          code: coupon.code,
          discount_type: coupon.discount_type,
          value: coupon.value,
          status: coupon.status,
          merchant_id: coupon.merchant_id.to_s,
          usage_count: coupon.invoices.count.to_s
        }
      }
    }
  end
end