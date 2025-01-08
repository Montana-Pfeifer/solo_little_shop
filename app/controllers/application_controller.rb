class ApplicationController < ActionController::API
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :bad_request_parse_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  

  private
  
  def record_not_found(exception)
    render json: ErrorSerializer.format_error(404, exception.message, "Record Not Found"), status: :not_found
  end

  def parameter_missing(exception)
    render json: ErrorSerializer.format_error(400, "Missing required parameter: #{exception.param}", "Bad Request"), status: :bad_request
  end

  def bad_request_parse_error(exception)
    render json: ErrorSerializer.format_error(400, "Error occurred while parsing request parameters", "Bad Request"), status: :bad_request
  end
end