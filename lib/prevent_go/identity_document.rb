# Params to pass to bank accounts:
# holder: { "firstName":"Quentin", "birthName":"Doe", "lastName":"Simpson", "birthDate":"1987-12-25", "gender":"M" } => (optional)
# file_1: file => required
# file_2: file => optional

module PreventGo
  class IdentityDocument < Base
    def holder_controls
      @_holder_controls ||= @request.dig('identityDocumentInfo', 'controlsGroups', 'holder') || {}
    end

    def holder_data
      @_holder_data ||= @request.dig('identityDocumentInfo', 'documentDetails', 'holder') || {}
    end

    def fetch_holder_infos(*keys)
      keys = default_holder_keys if keys.empty?
      holder_data.slice(*keys).values.compact
    end

    def quality_validated?
      [
        document_controls['typeRecognized'],
        document_controls.dig('quality', 'aboveMinimumThreshold'),
        document_controls['mrzValid']
      ].all? { |entry| entry == 'OK' }
    end

    def document_controls
      @_document_controls ||= @request.dig('identityDocumentInfo', 'controlsGroups', 'document') || {}
    end

    def document_details
      @_document_details ||= @request.dig('identityDocumentInfo', 'documentDetails') || {}
    end

    def not_expired?
      @request.dig('identityDocumentInfo', 'controlsGroups', 'document', 'notExpired') == 'OK'
    end

    private

    def default_holder_keys
      %w[firstName lastName birthName birthDate gender]
    end
  end
end
