return unless Rails.env.local?

require "ruby_parser"

class RubyParser
  def self.for_current_ruby
    name = "V#{RUBY_VERSION[/^\d+\.\d+/].delete "."}"
    klass = if const_defined? name
              const_get name
            else
              latest = VERSIONS.first
              # Silence warnings from this for now - can go away once RubyParser gets a proper 3.4 release
              # See also https://github.com/seattlerb/ruby_parser/issues/346
              # warn "NOTE: RubyParser::#{name} undefined, using #{latest}."
              latest
            end

    klass.new
  end
end

