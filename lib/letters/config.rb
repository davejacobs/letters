require "letters/assertion_error"

module Letters
  def self.defaults
    defaults = {
      a: { error_class: Letters::AssertionError },
      d1: { dup: false },
      d2: { format: "ap" },
      f: { format: "yaml", name: "log" },
      k: { on: 0 },
      l: { level: "info", format: "yaml" },
      o: { format: "ap", stream: $stdout },
      t: { time_format: "millis" }
    }

    defaults.tap do |hash|
      hash.default_proc = lambda {|h, k| h[k] = Hash.new }
    end
  end

  def self.global_defaults=(opts)
    @global_defaults = opts
  end

  def self.global_defaults
    @global_defaults || {}
  end

  def self.user_defaults
    @user_defaults ||= Hash.new {|h, k| h[k] = Hash.new }
  end

  def self.defaults_with(letter, opts={})
    # TODO: This is obviously a reduce, so change it to that
    global_defaults.merge(defaults[letter]).merge(user_defaults[letter]).merge(opts)
  end

  def self.reset_config!
    global_defaults.clear
    user_defaults.clear
  end

  def self.config(&block)
    Letters::Config.class_eval(&block)
  end

  module Config
    define_singleton_method("all") do |opts={}|
      Letters.global_defaults = opts
    end

    ("a".."z").each do |letter|
      define_singleton_method(letter) do |opts={}|
        Letters.user_defaults[letter.to_sym] = opts
      end
    end
  end
end
