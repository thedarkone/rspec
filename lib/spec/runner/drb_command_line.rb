require "drb/drb"

module Spec
  module Runner
    # Facade to run specs by connecting to a DRB server
    class DrbCommandLine
      # Runs specs on a DRB server. Note that this API is similar to that of
      # CommandLine - making it possible for clients to use both interchangeably.
      def self.run(options)
        retry_count = 30
        try_counter = 0
        begin
          DRb.start_service
          spec_server = DRbObject.new_with_uri("druby://127.0.0.1:8989")
          spec_server.run(options.argv, options.error_stream, options.output_stream)
        rescue DRb::DRbConnError => e
          try_counter += 1
          sleep(0.5) && retry if retry_count > try_counter
          options.error_stream.puts "No server is running"
        end
      end
    end
  end
end
