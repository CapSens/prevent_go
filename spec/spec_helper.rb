require "bundler/setup"
require "prevent_go"

Dir["#{Gem::Specification.find_by_name("prevent_go").gem_dir}/spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FixturesHelper
  config.include ConfigurationHelper
  config.extend VcrHelper

  config.before(:all) do
    reset_configuration
  end
end
