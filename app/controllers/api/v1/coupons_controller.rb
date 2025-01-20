class Api::V1::CouponsController < ApplicationController
  def index
    merchant = Merchant.find_by(id: params[:merchant_id])
    coupons = merchant.coupons
      render json: CouponSerializer.format_coupons(coupons)
  end
  

  def show
    merchant = Merchant.find_by(id: params[:merchant_id])
    if merchant.nil?
      render json: ErrorSerializer.format_error(404, "Merchant not found", "Record Not Found"), status: :not_found
      return
    end
  
    coupon = Coupon.find_by(id: params[:id])
    if coupon.nil?
      render json: ErrorSerializer.format_error(404, "Coupon not found for this merchant.", "Record Not Found"), status: :not_found
      return
    end
    
    render json: CouponSerializer.format_coupon(coupon)
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    new_coupon = merchant.coupons.create(coupon_params)
  
    if new_coupon.persisted?
      render json: CouponSerializer.format_coupon(new_coupon), status: :created
    else
      render json: { error: new_coupon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def deactivate
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find_by(id: params[:id])
  
    if coupon.nil?
      return render json: { error: "Coupon not found for this merchant." }, status: :not_found
    end
  
    if !coupon.status
      return render json: { error: "Coupon is already inactive." }, status: :unprocessable_entity
    end
  
    if coupon.invoices.pending.exists?
      return render json: { error: "Cannot deactivate coupon with pending invoices." }, status: :unprocessable_entity
    end
  
    if coupon.update(status: false)
      render json: CouponSerializer.format_coupon(coupon), status: :ok
    else
      render json: { error: "Failed to deactivate coupon." }, status: :unprocessable_entity
    end
  end

  def activate
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find_by(id: params[:id])
  
    if coupon.nil?
      return render json: { error: "Coupon not found for this merchant." }, status: :not_found
    end
  
    if coupon.status
      return render json: { error: "Coupon is already active." }, status: :unprocessable_entity
    end
  
    if coupon.update(status: true)
      render json: CouponSerializer.format_coupon(coupon), status: :ok
    else
      render json: { error: "Failed to activate coupon." }, status: :unprocessable_entity
    end
  end


  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :discount_type, :value, :status)
  end
end