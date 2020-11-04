module PreventGo
  class ResponseError < StandardError
    attr_reader :request_url, :code, :details

    def initialize(request_url, code, details)
      @request_url, @code, @details = request_url, code, details

      @details['Code'] = code
      @details['Url'] = request_url.request_uri

      super(message) if message
    end

    def type
      @details.dig('error', 'code')
    end

    def message
      @details.dig('error', 'message')
    end
  end
end
