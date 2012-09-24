require "letters/helpers"
require "letters/assertion_error"
require "letters/empty_error"
require "letters/nil_error"

module Letters
  module CoreExt
    DELIM = "-" * 20

    # Assert
    def a(opts={}, &block)
      opts = { error_class: AssertionError }.merge opts
      tap do |o|
        Helpers.message opts
        if block_given? && !o.instance_eval(&block)
          raise opts[:error_class]
        end
      end
    end

    # Beep
    def b(opts={})
      tap do
        Helpers.message opts
        $stdout.puts "\a"
      end
    end

    # Callstack
    def c(opts={})
      tap do
        Helpers.message opts
        trace = caller.length > 2 ? caller.slice(2..-1) : []
        Helpers.out trace
      end
    end

    # Debug
    def d(opts={})
      tap do
        Helpers.message opts
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
        Helpers.message opts
        Helpers.out diff, opts
        Letters.object_for_diff = nil
      end
    end
    
    # Empty check
    def e(opts={})
      # Override :error_class
      opts.merge! :error_class => EmptyError
      tap do |o|
        Helpers.message opts
        o.a(opts) { !empty? } 
      end
    end

    # File
    def f(opts={})
      opts = { name: "log", format: "yaml" }.merge opts
      tap do |o|
        File.open(opts[:name], "w+") do |file|
          # Override :stream
          opts.merge! :stream => file
          Helpers.message opts
          Helpers.out o, opts
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
      opts = { level: "info", format: "yaml" }.merge opts
      tap do |o|
        begin
          logger.send(opts[:level], opts[:message]) if opts[:message]
          logger.send(opts[:level], Helpers.send(opts[:format], o))
        rescue
          $stdout.puts "[warning] No logger available"
        end
      end
    end

    # Taint and untaint object
    def m(taint=true)
      tap do |o|
        if taint
          o.taint
        else
          o.untaint
        end
      end
    end

    # Nil check
    def n(opts={})
      tap do |o|
        o.a(:error_class => NilError) { !nil? } 
      end
    end

    # Print to STDOUT
    def p(opts={}, &block)
      opts = { format: "ap", stream: $stdout }.merge opts
      tap do |o|
        Helpers.message opts
        obj = block_given? ? o.instance_eval(&block) : o 
        Helpers.out obj, opts
      end
    end

    # RI
    def r(method=nil)
      require "rdoc/ri/driver"
      tap do |o|
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

    # Timestamp
    def t(opts={})
      tap do
        Helpers.message opts
        Helpers.out Time.now, opts
      end
    end
  end
end
