# Params to pass to bank accounts:
# holder: { "firstName":"Scarlette", "birthName":"Johansson", "lastName":"Bauer"} or {"legalEntityName":"NETHEOS"} => (optional)
# bank_account: { "iban":"FR7600000000000000000000000", "bicCode":"AGRIFRPP" } => (optional)
# file_1: file => required
# file_2: file => optional

module PreventGo
  class BankAccount < Base
    attr_accessor :params, :request

    def bic
      @request.dig('documentDetails', 'bicCode')
    end

    def iban
      @request.dig('documentDetails', 'iban')
    end

    private

    def endpoint
      '/bank-account'
    end
  end
end
