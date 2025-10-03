module Users
  module ImpersonatingBanner
    class Component < ApplicationComponent
      def render?
        helpers.current_user != helpers.true_user
      end
    end
  end
end

