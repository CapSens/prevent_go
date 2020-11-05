# Params to pass to bank accounts:
# holder: { "firstName":"James","lastName":"Bond","birthName": "Martinet","address": {"address1":"29 rue du Cheval blanc", "postalCode":"34000", "city":"Montpellier"}}
# file_1: file => required
# file_2: file => optional

module PreventGo
  class PropertyTaxNotice < Base
    def endpoint
      '/property-tax-notice'
    end

    def holder_controls
      @_holder_controls ||= @request.dig('controlsGroups', 'holder') || {}
    end
  end
end
