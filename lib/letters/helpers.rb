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

    # This provides a mockable method for testing
    def self.call_debugger
      require "ruby-debug"
      debugger
      nil
    end

    def self.change_safety(safety)
      $SAFE = safety
    end
  end
end
