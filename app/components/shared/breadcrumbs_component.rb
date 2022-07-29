module Shared
  class BreadcrumbsComponent < ApplicationComponent
    def initialize(links: [], title: nil, classes: "")
      @title = title
      @links = links
      @classes = classes
      super
    end

    private

    def styled_links
      @styled_links ||= @links.map do |link|
        link[:classes] = @classes
        if link == @links.last
          last_link_metadata(link)
        else
          link_metadata(link)
        end
      end
    end

    def link_metadata(link)
      link[:breadcrumb_class] = "breadcrumb-item"
      link[:aria_current] = false
      link[:last] = false
      link
    end

    def last_link_metadata(link)
      link[:breadcrumb_class] = "breadcrumb-item active"
      link[:aria_current] = "page"
      link[:last] = true
      link
    end
  end
end
