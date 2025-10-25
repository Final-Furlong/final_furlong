module Api
  class Base < Grape::API
    use Api::Base

    mount Api::V1::Base
  end
end

