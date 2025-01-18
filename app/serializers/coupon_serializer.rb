class CouponSerializer

  def self.format_coupons(coupons)
    { data:
    coupons.map do |coupon|
      {
        id: coupon.id.to_s,
        type: "coupon",
        attributes: {
          name: coupon.name,
          code: coupon.code
          discount_type: coupon.discount_type,
          value: coupon.value,
          status: coupon.status,
          merchant: coupon.merchant_id
        }
      }
    end
    }
  end
end