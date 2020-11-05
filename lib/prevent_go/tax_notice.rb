# Params to pass to bank accounts:
# holder_1: { "firstName":"James","lastName":"Bond" } => (optional)
# holder_2: { "firstName":"James","lastName":"Bond" } => (optional)
# taxHouseHold: {
#   "familyStatusCode":"SINGLE",
#   "partsCount":1.5,
#   "dependentPersonsCount":2,
#   "globalGrossIncome":23456,
#   "referenceIncome":12345,
#   "taxableIncome":1234,
#   "taxAmount":123,
#   "address": {"address1":"29 rue du Cheval blanc","postalCode":"34000","city":"Montpellier"}
# } => optional
# file_1: file => required

module PreventGo
  class TaxNotice < Base
    def endpoint
      '/tax-notice'
    end

    def holders_data
      @_holders_data ||=
        [@request.dig('taxNoticeDetails', 'holder1'), @request.dig('taxNoticeDetails', 'holder2')].compact
    end

    def quality_validated?
      [
        document_controls['typeRecognized'],
        document_controls.dig('quality', 'aboveMinimumThreshold'),
        document_controls['fiscalNumberFound']
      ].all? { |entry| entry == 'OK' }
    end

    def fetch_holders_infos(*keys)
      keys = default_holders_keys if keys.empty?
      holders_data.map { |holder| holder.compact.slice(*keys).values }
    end

    def default_holders_keys
      %w[firstName lastName birthName birthDate]
    end
  end
end
