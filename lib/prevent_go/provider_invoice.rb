# Params to pass to provider invoice:
# holder: { "firstName":"James","lastName":"Bond","birthName": "Martinet","address": {"address1":"29 rue du Cheval blanc", "postalCode":"34000", "city":"Montpellier"}} => (optional)
# file_1: file => required
# file_2: file => optional

module PreventGo
  class ProviderInvoice < Base
    def endpoint
      '/provider-invoice'
    end

    def holder_controls
      @_holder_controls ||= @request.dig('controlsGroups', 'holder') || {}
    end
  end
end
