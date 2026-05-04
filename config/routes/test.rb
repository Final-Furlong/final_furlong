if Rails.env.test?
  get "fake-sso", to: "test/sso#show", as: :fake_sso
end

