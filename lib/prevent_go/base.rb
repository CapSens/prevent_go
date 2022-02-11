module PreventGo
  class Base
    attr_accessor :params, :request

    def initialize(file_front, file_back=nil, **params)
      @params = PreventGo.concat_params([file_front, file_back], params)
      @request = PreventGo.request(endpoint, @params)
    end

    def document_type
      @request["documentType"]
    end

    def document_details
      @_document_details ||= @request['documentDetails'] || {}
    end

    def document_controls
      @_document_controls ||= @request.dig('controlsGroups', 'document') || {}
    end

    def holder_controls
      @_holder_controls ||= @request.dig('controlsGroups', 'holder')
    end

    def quality_validated?
      [
        document_controls['typeRecognized'],
        document_controls.dig('quality', 'aboveMinimumThreshold'),
      ].all? { |entry| entry == 'OK' }
    end

    private

    def endpoint
      '/any'
    end
  end
end
