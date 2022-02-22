# Params to pass to bank accounts:
# holder: { "firstName":"Scarlette", "birthName":"Johansson", "lastName":"Bauer"} or {"legalEntityName":"NETHEOS"} => (optional)
# bank_account: { "iban":"FR7600000000000000000000000", "bicCode":"AGRIFRPP" } => (optional)
# file_1: file => required
# file_2: file => optional

module PreventGo
  class BankAccount < Base
    attr_accessor :params, :request

    def bic
      @request.dig('bankAccountInfo', 'documentDetails', 'bicCode')
    end

    def iban
      @request.dig('bankAccountInfo', 'documentDetails', 'iban')
    end

    def document_details
      @_document_details ||= @request.dig('bankAccountInfo', 'documentDetails') || {}
    end

    def document_controls
      @_document_controls ||= @request.dig('bankAccountInfo', 'controlsGroups', 'document') || {}
    end

    def holder_controls
      @_holder_controls ||= @request.dig('bankAccountInfo', 'controlsGroups', 'holder')
    end
  end
end
