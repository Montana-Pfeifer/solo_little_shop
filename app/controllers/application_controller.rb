class ApplicationController < ActionController::API
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :bad_request
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from InvalidPriceError, with: :handle_invalid_price_params
  rescue_from InvalidPriceParamsError, with: :handle_invalid_price_params
  rescue_from InvalidCouponStatusError, with: :handle_invalid_coupon_status

  private

  def bad_request(exception)
    render json: ErrorSerializer.format_error(400, exception.message, "Bad Request"), status: :bad_request
  end

  def record_not_found(exception)
    render json: ErrorSerializer.format_error(404, exception.message, "Record Not Found"), status: :not_found
  end

  def record_invalid(exception)
    render json: ErrorSerializer.format_error(422, exception.message, "Unprocessable_entity"), status: :unprocessable_entity
  end

  def validate_price_params
    if params[:max_price].present?
      max_price = params[:max_price].to_f
      raise InvalidPriceError, "max_price must be greater than or equal to 0." if max_price < 0
    end

    if params[:min_price].present?
      min_price = params[:min_price].to_f
      raise InvalidPriceError, "min_price must be greater than or equal to 0." if min_price < 0
    end
  end

  def handle_invalid_price_params(exception)
    render json: ErrorSerializer.format_error(400, exception.message, "Invalid Price Range"), status: :bad_request
  end

  def handle_invalid_coupon_status(exception)
    render json: ErrorSerializer.format_error(422, exception.message, "Unprocessable Entity"), status: :unprocessable_entity
  end
end