module ActionDispatch
  module Integration #:nodoc:
    module MonitoringSession
      def get_with_benchmark(path, parameters = nil, headers_or_env = nil)
        process_with_benchmark :get, path, parameters, headers_or_env
      end

      def post_with_benchmark(path, parameters = nil, headers_or_env = nil)
        process_with_benchmark :post, path, parameters, headers_or_env
      end

      def patch_with_benchmark(path, parameters = nil, headers_or_env = nil)
        process_with_benchmark :patch, path, parameters, headers_or_env
      end

      def put_with_benchmark(path, parameters = nil, headers_or_env = nil)
        process_with_benchmark :put, path, parameters, headers_or_env
      end

      def delete_with_benchmark(path, parameters = nil, headers_or_env = nil)
        process_with_benchmark :delete, path, parameters, headers_or_env
      end

      def head_with_benchmark(path, parameters = nil, headers_or_env = nil)
        process_with_benchmark :head, path, parameters, headers_or_env
      end

      private

      def process_with_benchmark(method, path, parameters = nil, headers_or_env = nil)
        measures_types = %i[db view total]
        @durations = {db: 0, view: 0, total: 0}

        ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |_, start, finish, _, payload|
          @durations[:db] += payload[:db_runtime].to_f
          @durations[:view] += payload[:view_runtime].to_f
          @durations[:total] += (finish - start) * 1_000
        end

        status = process(method, path, parameters, headers_or_env)

        ActiveSupport::Notifications.unsubscribe 'process_action.action_controller'

        response.durations = @durations
        status
      end
    end

    class Session
      prepend ActionDispatch::Integration::MonitoringSession
    end
  end
end
