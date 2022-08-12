if Rails.env.development? && ENV.fetch("DEBUG", false)
  require "byebug/core"
  begin
    Byebug.start_server "localhost", ENV.fetch("BYEBUG_SERVER_PORT", 8989).to_i
  rescue Errno::EADDRINUSE
    nil
  end
end

