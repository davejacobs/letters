require "letters/config"
require "letters/helpers"
require "letters/diff"
require "letters/kill"
require "letters/time_formats"
require "letters/empty_error"
require "letters/kill_error"
require "letters/nil_error"

require "colorize"

module Letters
  module CoreExt
    DELIM = "-" * 20

    def ubertap(letter, opts={}, orig_caller=[], &block)
      full_opts = Letters.defaults_with(letter, opts)
      Helpers.message full_opts
      Helpers.print_line(orig_caller[0]) if full_opts[:line_no]

      tap do |o|
        block.call(o, full_opts)
      end
    end

    # Assert
    def a(opts={}, &block)
      ubertap(:a, opts, caller) do |o, full_opts|
        if block_given? && !o.instance_eval(&block)
          raise full_opts[:error_class]
        end
      end
    end

    # Beep
    def b(opts={})
      ubertap(:b, opts, caller) do |_, _|
        $stdout.print "\a"
      end
    end

    # Callstack
    def c(opts={})
      ubertap(:b, opts, caller) do |_, full_opts|
        Helpers.out caller(4), full_opts
      end
    end

    # Debug
    def d(opts={})
      ubertap(:d, opts, caller) do |_, _|
        Helpers.call_debugger
      end
    end

    # Diff 1
    def d1(opts={})
      ubertap(:d1, opts, caller) do |o, _|
        Letters.object_for_diff = o
      end
    end

    # Diff 2
    def d2(opts={})
      ubertap(:d2, opts, caller) do |o, full_opts|
        diff = Helpers.diff(Letters.object_for_diff, o)
        Helpers.out diff, full_opts
        Letters.object_for_diff = nil
      end
    end

    # Empty check
    def e(opts={})
      opts.merge! :error_class => EmptyError
      ubertap(:e, opts, caller) do |o, full_opts|
        o.a(full_opts) { !empty? }
      end
    end

    # File
    def f(opts={})
      ubertap(:f, opts, caller) do |o, full_opts|
        suffixes = [""] + (1..50).to_a
        deduper = suffixes.detect {|x| !File.directory? "#{full_opts[:name]}#{x}" }

        File.open("#{full_opts[:name]}#{deduper}", "w+") do |file|
          # Override :stream
          full_opts.merge! :stream => file
          Helpers.out o, full_opts
        end
      end
    end

    # Jump
    def j(opts={}, &block)
      ubertap(:j, opts, caller) do |o, full_opts|
        o.instance_eval &block
      end
    end

    # Kill
    def k(opts={})
      opts.merge! :error_class => KillError
      ubertap(:k, opts, caller) do |o, full_opts|
        # Support :max option until I can deprecate it
        full_opts[:on] ||= full_opts[:max]

        Letters.kill_count ||= 0

        if Letters.kill_count >= full_opts[:on]
          Letters.kill_count = 0
          o.a(full_opts) { false }
        end

        Letters.kill_count += 1
      end
    end

    # Log
    def l(opts={})
      ubertap(:l, opts, caller) do |o, full_opts|
        begin
          logger.send(full_opts[:level], full_opts[:message]) if full_opts[:message]
          logger.send(full_opts[:level], Helpers.send(full_opts[:format], o))
        rescue
          $stdout.puts "[warning] No logger available"
        end
      end
    end

    # Taint and untaint object
    def m(taint=true, opts={})
      ubertap(:m, opts, caller) do |o, _|
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
      ubertap(:n, opts, caller) do |o, full_opts|
        o.a(full_opts) { !nil? }
      end
    end

    # Print to STDOUT
    def o(opts={}, &block)
      ubertap(:o, opts, caller) do |o, full_opts|
        Helpers.message full_opts
        obj = block_given? ? o.instance_eval(&block) : o
        Helpers.out obj, full_opts
      end
    end

    # RI
    def r(method=nil, opts={})
      ubertap(:r, opts, caller) do |o, _|
        method_or_empty = method ? "##{method}" : method
        system "ri #{o.class}#{method_or_empty}"
      end
    end

    # Change safety level
    def s(level=nil, opts={})
      ubertap(:s, opts) do |_, _|
        level ||= $SAFE + 1
        Helpers.change_safety level
      end
    end

    # Timestamp
    def t(opts={})
      ubertap(:t, opts) do |_, full_opts|
        Helpers.out Time.now.to_s(full_opts[:time_format].to_sym), full_opts
      end
    end
  end
end
