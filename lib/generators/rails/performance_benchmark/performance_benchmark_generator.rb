module Rails
  module Generators
    class PerformanceBenchmarkGenerator < NamedBase # :nodoc:
      check_class_collision suffix: "Test"

      source_root File.expand_path("../templates", __FILE__)

      def create_performance_test_file
        template 'performance_benchmark.rb', File.join('test/performance', class_path, "#{file_name}_benchmark.rb")
      end

    end
  end
end
