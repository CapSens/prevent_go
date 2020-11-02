# Params to pass to bank accounts:
# holder: { "firstName":"Quentin", "birthName":"Doe", "lastName":"Simpson", "birthDate":"1987-12-25", "gender":"M" } => (optional)
# file_1: file => required
# file_2: file => optional

module PreventGo
  class Identity < Base

    def holder_controls
      @_holder_controls ||= @request.dig('controlsGroups', 'holder') || {}
    end

    def holder_data
      @_holder_data || @request.dig('documentDetails', 'holder') || {}
    end

    def fetch_holder_infos(*keys)
      keys = default_holder_keys if keys.empty?
      holder_data.slice(*keys).values.compact
    end

    def quality_validated?
      [
        document_controls['typeRecognized'],
        document_controls.dig('quality', 'aboveMinimumThreshold'),
        document_controls['notExpired'],
        document_controls['mrzValid']
      ].all? { |entry| entry == 'OK' }
    end

    def not_expired?
      @request.dig('controlsGroups', 'document', 'notExpired') == 'OK'
    end

    private

    def endpoint
      '/identity/individual'
    end

    def default_holder_keys
      %w[firstName lastName birthName birthDate gender]
    end
  end
end
