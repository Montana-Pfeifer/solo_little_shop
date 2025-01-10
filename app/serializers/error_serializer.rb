class ErrorSerializer
  def self.format_errors(errors)
    {
      message: "There was errors processing your request",
      errors: errors.map do |error|
        {
          status: error[:status].to_s,
          title: error[:title] || "Error",
          detail: error[:detail],
          message: error[:message] || "An error occurred"
        }
      end
    }
  end
  
  def self.format_error(status, detail, title = "Error", message = "An error occurred")
    format_errors([{ status: status, title: title, detail: detail, message: message }])
  end
end