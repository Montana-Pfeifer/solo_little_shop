class ErrorSerializer
  def self.format_errors(errors)
    {
      message: "There were errors processing your request",
      errors: errors.map do |error|
        {
          status: error[:status].to_s,
          title: error[:title],
          detail: error[:detail]
        }
      end
    }
  end

  
  def self.format_error(status, detail, title = "Error", message = "An error occurred")
    format_errors([{ status: status, title: title, detail: detail, message: message }])
  end
end