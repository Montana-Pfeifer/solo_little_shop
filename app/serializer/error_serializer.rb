class ErrorSerializer
  def self.format_errors(errors)
    {
      errors: errors.map do |error|
        {
          status: error[:status].to_s, 
          title: error[:title] || "Error",
          detail: error[:detail]
        }
      end
    }
  end

  def self.format_error(status, detail, title = "Error")
    format_errors([{ status: status, title: title, detail: detail }])
  end
end