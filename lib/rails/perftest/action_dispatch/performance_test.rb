require 'rails/perftest/active_support/testing/performance'
require 'rails/perftest/action_dispatch/integration/session'
require 'rails/perftest/action_dispatch/response'

module ActionDispatch
  # An integration test that runs a code profiler on your test methods.
  # Profiling output for combinations of each test method, measurement, and
  # output format are written to your tmp/performance directory.
  class PerformanceTest < ActionDispatch::IntegrationTest
    include ActiveSupport::Testing::Performance

    minitest_version = Gem.loaded_specs["minitest"].version

    if minitest_version < Gem::Version.create('5.0.0')
      include Minitest4AndLower
    elsif minitest_version < Gem::Version.create('5.11.0')
      include Minitest5
    else
      include Minitest511AndGreater
    end

    autoload :TimeAssertions, File.expand_path(__dir__) + "/assertions/runtime"

    include TimeAssertions
  end
end
