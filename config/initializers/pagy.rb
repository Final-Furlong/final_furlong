# frozen_string_literal: true

# Pagy initializer file (43.0.0)
# See https://ddnexus.github.io/pagy/resources/initializer/

############ Global Options ################################################################
# See https://ddnexus.github.io/pagy/toolbox/options/ for details.
# Add your global options below. They will be applied globally.
# For example:
#
# Pagy.options[:limit] = 10               # Limit the items per page
# Pagy.options[:client_max_limit] = 100   # The client can request a limit up to 100
# Pagy.options[:max_pages] = 200          # Allow only 200 pages
# Pagy.options[:jsonapi] = true           # Use JSON:API compliant URLs

############ JavaScript ####################################################################
# See https://ddnexus.github.io/pagy/resources/javascript/ for details.
# Examples for Rails:
# For apps with an assets pipeline
# Rails.application.config.assets.paths << Pagy::ROOT.join('javascripts')
#
# For apps with a javascript builder (e.g. esbuild, webpack, etc.)
# javascript_dir = Rails.root.join('app/javascript')
# Pagy.sync_javascript(javascript_dir, 'pagy.mjs') if Rails.env.development?

############# Overriding Pagy::I18n Lookup #################################################
# Refer to https://ddnexus.github.io/pagy/resources/i18n/ for details.
# Override the dictionary lookup for customization by dropping your customized
# Example for Rails:
#
# Pagy::I18n.pathnames << Rails.root.join('config/locales')

############# I18n Gem Translation #########################################################
# See https://ddnexus.github.io/pagy/resources/i18n/ for details.
#
# Pagy.translate_with_the_slower_i18n_gem!

############# Calendar Localization for non-en locales ####################################
# See https://ddnexus.github.io/pagy/toolbox/paginators/calendar#localization for details.
# Add your desired locales to the list and uncomment the following line to enable them,
# regardless of whether you use the I18n gem for translations or not, whether with
# Rails or not.
#
# Pagy::Calendar.localize_with_rails_i18n_gem(*your_locales)

# Instance variables
# Pagy.options[:page]   = 1                                  # default
# Pagy.options[:items]  = 20                                 # default

# Other Variables
# Pagy.options[:size]       = [1,4,4,1]                       # default
# Pagy.options[:page_param] = 'page'                          # default
# The :params can be also set as a lambda e.g ->(params){ params.exclude('useless').merge!('custom' => 'useful') }
# Pagy.options[:params]     = {}                              # default
# Pagy.options[:fragment]   = 'fragment'                      # example
# Pagy.options[:link_extra] = 'data-remote="true"'            # example
# Pagy.options[:i18n_key]   = 'pagy.item_name'                # default

Pagy.options[:headless] = false # default (eager loading)

# Elasticsearch Rails extra: Paginate `ElasticsearchRails::Results` objects
# See https://ddnexus.github.io/pagy/extras/elasticsearch_rails
# Default :pagy_search method: change only if you use also
# the searchkick or meilisearch extra that defines the same
# Pagy.options[:elasticsearch_rails_pagy_search] = :pagy_search
# Default original :search method called internally to do the actual search
# Pagy.options[:elasticsearch_rails_search] = :search

# Headers extra: http response headers (and other helpers) useful for API pagination
# See http://ddnexus.github.io/pagy/extras/headers
# Pagy.options[:headers] = { page: 'Current-Page',
#                            items: 'Page-Items',
#                            count: 'Total-Count',
#                            pages: 'Total-Pages' }     # default

# Meilisearch extra: Paginate `Meilisearch` result objects
# See https://ddnexus.github.io/pagy/extras/meilisearch
# Default :pagy_search method: change only if you use also
# the elasticsearch_rails or searchkick extra that define the same method
# Pagy.options[:meilisearch_pagy_search] = :pagy_search
# Default original :search method called internally to do the actual search
# Pagy.options[:meilisearch_search] = :ms_search

# Metadata extra: Provides the pagination metadata to Javascript frameworks like Vue.js, react.js, etc.
# See https://ddnexus.github.io/pagy/extras/metadata
# you must require the shared internal extra (BEFORE the metadata extra) ONLY if you need also the :sequels
# For performance reasons, you should explicitly set ONLY the metadata you use in the frontend
# Pagy.options[:metadata] = %i[scaffold_url page prev next last]   # example

# Searchkick extra: Paginate `Searchkick::Results` objects
# See https://ddnexus.github.io/pagy/extras/searchkick
# Default :pagy_search method: change only if you use also
# the elasticsearch_rails or meilisearch extra that defines the same
# DEFAULT[:searchkick_pagy_search] = :pagy_search
# Default original :search method called internally to do the actual search
# Pagy.options[:searchkick_search] = :search
# uncomment if you are going to use Searchkick.pagy_search
# Searchkick.extend Pagy::Searchkick

# Multi size var used by the *_nav_js helpers
# See https://ddnexus.github.io/pagy/extras/navs#steps
# Pagy.options[:steps] = { 0 => [2,3,3,2], 540 => [3,5,5,3], 720 => [5,7,7,5] }   # example

# Gearbox extra: Automatically change the number of items per page depending on the page number
# set to false only if you want to make :gearbox_extra an opt-in variable
# Pagy.options[:gearbox_extra] = false               # default true
# Pagy.options[:gearbox_items] = [15, 30, 60, 100]   # default

# Items extra: Allow the client to request a custom number of items per page with an optional selector UI
# set to false only if you want to make :items_extra an opt-in variable
# Pagy.options[:items_extra] = false    # default true
# Pagy.options[:items_param] = :items   # default
# Pagy.options[:max_items]   = 100      # default

# Overflow extra: Allow for easy handling of overflowing pages
# See https://ddnexus.github.io/pagy/extras/overflow
# Pagy.options[:overflow] = :empty_page    # default  (other options: :last_page and :exception)

# Standalone extra: Use pagy in non Rack environment/gem
# See https://ddnexus.github.io/pagy/extras/standalone
# Pagy.options[:url] = 'http://www.example.com/subdir'  # optional default

# Default i18n key
# Pagy.options[:i18n_key] = 'pagy.item_name'   # default

# When you are done setting your own default freeze it, so it will not get changed accidentally
Pagy.options.freeze

