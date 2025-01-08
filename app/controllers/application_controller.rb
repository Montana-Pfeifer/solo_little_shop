class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :bad_request_parse_error

  private

  def missing_item_params?
    params[:item].nil? || params[:item][:name].blank? || params[:item][:price].blank? || params[:item][:description].blank?
  end

  def record_not_found(exception)
    render json: ErrorSerializer.format_error(404, exception.message, "Record Not Found"), status: :not_found
  end

  def record_invalid(exception)
    render json: ErrorSerializer.format_error(422, exception.record.errors.full_messages.join(", "), "Validation Error"), status: :unprocessable_entity
  end

  def render_bad_request(exception)
    render json: ErrorSerializer.format_error(400, exception, "Bad Request"), status: :bad_request
  end

  def bad_request_parse_error(exception)
    render json: ErrorSerializer.format_error(400, "Error occurred while parsing request parameters", "Bad Request"), status: :bad_request
  end
end