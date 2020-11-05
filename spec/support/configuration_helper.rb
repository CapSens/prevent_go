module ConfigurationHelper
  def reset_configuration
    PreventGo.configure do |config|
      config.site_key = 'test'
      config.secret_key = 'test'
      config.api_root_url = 'https://integration-api.preventgo.io/v2'
    end
  end
end
