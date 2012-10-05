require 'letters'
require 'set'
module Letters

  def self.uses
    @@letters_usage ||= Set.new
  end

  module CoreExt

    def letters_tap(&bl)
      Letters.uses << caller[1]
      tap(&bl)
    end

  end
end

at_exit{
  require 'awesome_print'
  ap "Letters were used at:", color: {:string => :red}
  ap Letters.uses.to_a
}