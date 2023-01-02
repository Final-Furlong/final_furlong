# monkey patch
# https://rom-rb.org/learn/rails/2.2/#running-alongside-activerecord
module ROM
  module Rails
    class Railtie < ::Rails::Railtie
      alias create_container! create_container
      def create_container
        create_container!
      rescue StandardError => e
        puts "Container failed to initialize because of #{e.inspect}"
        puts "This message comes from the monkey patch in #{__FILE__}, if you are using rake, then this is fine"
      end
    end
  end
end

ROM::Rails::Railtie.configure do |config|
  config.gateways[:default] = [:sql, ENV.fetch("DATABASE_URL"), { extensions: %i[pg_timestamptz] }]
end

