require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "#{Gem::Specification.find_by_name("prevent_go").gem_dir}/spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.allow_http_connections_when_no_cassette = false
end
