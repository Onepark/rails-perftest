require 'generators/generators_test_helper'
require 'generators/rails/performance_benchmark/performance_benchmark_generator'

class PerformanceTestGeneratorTest < Rails::Generators::TestCase
  tests Rails::Generators::PerformanceBenchmarkGenerator
  arguments %w(dashboard)
  destination File.expand_path("../../tmp", __FILE__)

  def setup
    super
    prepare_destination
  end

  def test_performance_test_skeleton_is_created
    run_generator
    assert_file "test/performance/dashboard_benchmark.rb", /class DashboardBenchmark < ActionDispatch::PerformanceTest/
  end
end
