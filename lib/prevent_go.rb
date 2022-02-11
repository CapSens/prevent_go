require 'mime/types'
require 'json'
require 'net/http'
require 'net/http/post/multipart'

require 'prevent_go/version'
require 'prevent_go/configuration'
require 'prevent_go/response_error'

module PreventGo
  autoload :Base, 'prevent_go/base'
  autoload :AddressDocument, 'prevent_go/address_document'
  autoload :BankAccount, 'prevent_go/bank_account'
  autoload :IdentityDocument, 'prevent_go/identity_document'
  autoload :TaxNotice, 'prevent_go/tax_notice'

  class << self
    def configuration
      @configuration ||= PreventGo::Configuration.new
    end

    def configure
      yield(configuration)
    end

    def api_root_url
      configuration.api_root_url
    end

    def api_uri(path='')
      URI(api_root_url + path)
    end

    def request(url, params={})
      uri = api_uri(url)

      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true, read_timeout: 1000) do |http|
        req = Net::HTTP::Post::Multipart.new(uri.request_uri, params)
        req.basic_auth(ENV['PREVENT_GO_ID'], ENV['PREVENT_GO_SECRET'])
        http.request(req)
      end

      # decode json data
      data = res.body.to_s.empty? ? {} : JSON.parse(res.body.to_s)

      raise PreventGo::ResponseError.new(uri, res.code, data) unless res.is_a?(Net::HTTPOK)

      data
    end

    def detect_mime_type_for(file)
      if file.respond_to?(:content_type)
        file.content_type
      elsif file.respond_to?(:path)
        MIME::Types.type_for(File.basename(file.path))[0]
      elsif file.is_a?(String)
        MIME::Types.type_for(File.basename(file))[0]
      else
        ''
      end
    end

    def concat_params(files, params={})
      params = params.each { |k, v| params[k] = JSON.dump(v) }
      files.compact.each.with_index(1) do |file, index|
        params["file_#{index}"] = UploadIO.new(file, detect_mime_type_for(file))
      end
      params
    end
  end
end
