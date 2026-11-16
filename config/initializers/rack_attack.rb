if Rails.env.production?
  class Rack::Attack
    Rack::Attack.blocklist("bad-robots") do |req|
      req.ip if /\S+\.php/.match?(req.path)
    end

    # prevent bots from hammering sign-up flow
    Rack::Attack.throttle("users/sign_up", limit: 3, period: 15.minutes) do |req|
      req.ip if req.path == "/users" && req.post?
    end
    Rack::Attack.throttle("join", limit: 3, period: 15.minutes) do |req|
      req.ip if req.path == "/users" && req.post?
    end
  end
end

