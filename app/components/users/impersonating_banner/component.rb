module Users
  module ImpersonatingBanner
    class Component < ApplicationComponent
      def render?
        Current.user != helpers.true_user
      end
    end
  end
end

