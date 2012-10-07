require "letters/config"
require "letters/helpers"
require "letters/diff"
require "letters/time_formats"
require "letters/empty_error"
require "letters/kill_error"
require "letters/nil_error"

module Letters
  module CoreExt
    DELIM = "-" * 20

    # Assert
    def a(opts={}, &block)
      opts = Letters.defaults_with(:a, opts)
      tap do |o|
        Helpers.message opts
        if block_given? && !o.instance_eval(&block)
          raise opts[:error_class]
        end
      end
    end

    # Beep
    def b
      tap do
        $stdout.print "\a"
      end
    end

    # Callstack
    def c(opts={})
      tap do
        Helpers.message opts
        Helpers.out caller(4), opts
      end
    end

    # Debug
    def d
      tap do
        Helpers.call_debugger 
      end
    end

    # Diff 1
    def d1
      tap do |o|
        Letters.object_for_diff = o
      end
    end

    # Diff 2
    def d2(opts={})
      opts = Letters.defaults_with(:d2, opts)
      tap do |o|
        diff = Helpers.diff(Letters.object_for_diff, o)
        Helpers.message opts
        Helpers.out diff, opts
        Letters.object_for_diff = nil
      end
    end
    
    # Empty check
    def e(opts={})
      opts.merge! :error_class => EmptyError
      tap do |o|
        Helpers.message opts
        o.a(opts) { !empty? } 
      end
    end

    # File
    def f(opts={})
      opts = Letters.defaults_with(:f, opts)
      tap do |o|
        suffixes = [""] + (1..50).to_a
        deduper = suffixes.detect {|x| !File.directory? "#{opts[:name]}#{x}" }

        File.open("#{opts[:name]}#{deduper}", "w+") do |file|
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

    # Kill
    def k(opts={})
      opts = Letters.defaults_with(:k, opts)
      opts.merge! :error_class => KillError
      tap do |o|
        @letters_kill_count ||= 0
        if @letters_kill_count >= opts[:max]
          raise opts[:error_class]
        end
        @letters_kill_count += 1
      end
    end

    # Log
    def l(opts={})
      opts = Letters.defaults_with(:l, opts)
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
      opts.merge! :error_class => NilError
      tap do |o|
        o.a(opts) { !nil? } 
      end
    end

    # Print to STDOUT
    def o(opts={}, &block)
      opts = Letters.defaults_with(:o, opts)
      tap do |o|
        Helpers.message opts
        obj = block_given? ? o.instance_eval(&block) : o 
        Helpers.out obj, opts
      end
    end

    # RI
    def r(method=nil)
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
      opts = Letters.defaults_with(:t, opts)
      tap do
        Helpers.message opts
        Helpers.out Time.now.to_s(opts[:time_format].to_sym), opts
      end
    end
  end
end
