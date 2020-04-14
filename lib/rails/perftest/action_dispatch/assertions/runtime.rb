module ActionDispatch
  module Assertions
    module TimeAssertions
      def assert_runtime(type, operator, expected, message = nil)
        @assert_runtime ||= {}
        @assert_runtime[type] ||= {}

        value = response.durations[type]

        @assert_runtime[type][:count] ||= 0
        @assert_runtime[type][:total] ||= 0
        metrics_count = self.profile_options.fetch(:metrics).size
        @assert_runtime[type][:runs] ||= self.profile_options[:runs].to_i * metrics_count

        return if @assert_runtime[type][:runs] == 0

        if @assert_runtime[type][:count] < @assert_runtime[type][:runs]
          @assert_runtime[type][:count] += 1
          @assert_runtime[type][:total] += value
          return
        end

        average_value = @assert_runtime[type][:total] / @assert_runtime[type][:count]

        message ||= (+"Expected #{type} runtime to be #{operator == :<= ? 'lower' : 'greater'} than #{expected},"\
          " but was #{average_value}")

        assert_operator average_value, operator, expected, message
      end

      def refute_runtime(type, operator, expected, message = nil)
        assert_runtime(type, [:>=, :>].include?(operator) ? :<= : :>= , expected, message = nil)
      end
    end
  end
end
