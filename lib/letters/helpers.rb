require "colorize"

module Letters
  module Helpers
    def self.diff(obj1, obj2)
      case obj2
      when Hash
        {
          removed: obj1.reject {|k, v| obj2.include? k },
          added:   obj2.reject {|k, v| obj1.include? k },
          updated: obj2.select {|k, v| obj1.include?(k) && obj1[k] != v }
        }
      when String
        diff(obj1.split("\n"), obj2.split("\n"))
      else
        { 
          removed: Array(obj1 - obj2),
          added: Array(obj2 - obj1)
        }
      end
    rescue
      raise "cannot diff the two marked objects" 
    end

    def self.message(opts={})
      out(opts[:message], opts) if opts[:message]
    end

    def self.out(object, opts={})
      opts = { stream: $stdout, format: "string" }.merge opts
      opts[:stream].puts Helpers.send(opts[:format], object)
    end

    def self.ap(object)
      require "awesome_print"
      object.awesome_inspect
    end

    def self.json(object)
      require "json"
      object.to_json
    end

    def self.pp(object)
      require "pp"
      object.pretty_inspect
    end

    def self.string(object)
      object.to_s
    end

    def self.xml(object)
      require "xmlsimple"
      XmlSimple.xml_out(object, { "KeepRoot" => true })
    end

    def self.yaml(object)
      require "yaml"
      object.to_yaml
    end

    def self.pretty_callstack(callstack)
      home = ENV["MY_RUBY_HOME"]

      parsed = callstack.map do |entry|
        line, line_no, method_name = entry.split ":"

        {
          line: line.gsub(home + "/", "").green,
          line_no: line_no.yellow,
          method_name: method_name.scan(/`([^\']+)'/).first.first.light_blue
        }
      end

      headers = {
        line: "Line".green,
        line_no: "No.".yellow,
        method_name: "Method".light_blue
      }

      parsed.unshift headers

      longest_line = 
        parsed.map {|entry| entry[:line] }.
          sort_by(&:length).
          last

      longest_method = 
        parsed.map {|entry| entry[:method_name] }.
          sort_by(&:length).
          last

      formatter = "%#{longest_method.length}{method_name} %-#{longest_line.length}{line} %{line_no}\n"

      parsed.map {|h| formatter % h }.join
    end

    # This provides a mockable method for testing
    def self.call_debugger
      if (defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx')
        require 'rubinius/debugger'
        Rubinius::Debugger.start
      else
        require 'debug'
      end

      nil
    end

    def self.change_safety(safety)
      $SAFE = safety
    end
  end
end
