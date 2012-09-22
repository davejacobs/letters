require "letters/helpers"
require "letters/empty_error"
require "letters/nil_error"

module Letters
  module CoreExt
    DELIM = '-' * 20

    # Beep
    def b(opts={})
      tap do
        $stdout.puts opts[:message] if opts[:message]
        $stdout.puts "\a"
      end
    end

    # Callstack
    def c(opts={})
      tap do
        $stdout.puts opts[:message] if opts[:message]
        trace = caller.length > 2 ? caller.slice(2..-1) : []
        $stdout.puts trace
      end
    end

    # Debug
    def d(opts={})
      tap do
        $stdout.puts opts[:message] if opts[:message]
        Helpers.call_debugger 
      end
    end

    def d1
      tap do |o|
        Letters.object_for_diff = o
      end
    end

    def d2(opts={})
      require "awesome_print"
      opts = { format: "ap" }.merge opts
      tap do |o|
        diff = Helpers.diff(Letters.object_for_diff, o)
        Helpers.out diff, :format => opts[:format]
        Letters.object_for_diff = nil
      end
    end
    
    # Empty check
    def e(opts={})
      tap do |o|
        raise EmptyError if o.empty?
      end
    end

    # File
    def f(opts={})
      opts = { name: "log", format: "yaml" }.merge opts
      tap do |o|
        File.open(opts[:name], "w+") do |file|
          Helpers.out o, :stream => file, :format => opts[:format]
        end
      end
    end

    # Jump
    def j(&block)
      tap do |o|
        o.instance_eval &block
      end
    end

    # Log
    def l(opts={})
      opts = { level: :info, format: :yaml }.merge opts
      tap do |o|
        begin
          logger.send(opts[:level], opts[:message]) if opts[:message]
          logger.send(opts[:level], Helpers.send(opts[:format], o))
        rescue
          $stdout.puts "[warning] No logger available"
        end
      end
    end

    # Nil check
    def n(opts={})
      tap do |o|
        raise NilError if o.nil?
      end
    end

    # Print to STDOUT
    def p(opts={}, &block)
      opts = { format: :ap, stream: $stdout }.merge opts
      tap do |o|
        obj = block_given? ? o.instance_eval(&block) : o 
        Helpers.out obj, opts
      end
    end

    # RI
    def r(method=nil, opts={})
      require "rdoc/ri/driver"
      tap do |o|
        $stdout.puts opts[:message] if opts[:message]
        method_or_empty = method ? "##{method}" : method
        system "ri #{o.class}#{method_or_empty}" 
      end
    end

    # Change safety level
    def s(level=nil)
      tap do
        level ||= $SAFE + 1
        Helpers.change_safety level
      end
    end

    # Taint object
    def t
      tap do |o|
        o.taint
      end
    end

    # Untaint object
    def u
      tap do |o|
        o.untaint
      end
    end
  end
end
