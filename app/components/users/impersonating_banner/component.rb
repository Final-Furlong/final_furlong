module Users
  module ImpersonatingBanner
    class Component < ApplicationViewComponent
      def render?
        helpers.current_user != helpers.true_user
      end
    end
  end
end

