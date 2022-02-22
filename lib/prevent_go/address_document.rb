# Params to pass to provider invoice:
# holder: { "firstName":"James","lastName":"Bond","birthName": "Martinet","address": {"address1":"29 rue du Cheval blanc", "postalCode":"34000", "city":"Montpellier"}} => (optional)
# file_1: file => required
# file_2: file => optional

module PreventGo
  class AddressDocument < Base
    def holder_controls
      @_holder_controls ||= @request.dig('addressDocumentInfo', 'controlsGroups', 'holder') || {}
    end

    def document_details
      @_document_details ||= @request.dig('addressDocumentInfo', 'documentDetails') || {}
    end

    def document_controls
      @_document_controls ||= @request.dig('addressDocumentInfo', 'controlsGroups', 'document') || {}
    end
  end
end
