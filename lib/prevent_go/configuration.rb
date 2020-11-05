module PreventGo
  class Configuration
    attr_accessor :site_key, :secret_key, :api_root_url

    def initialize
      @site_key = nil
      @secret_key = nil
      @api_root_url = nil
    end
  end
end
