require "letters/helpers"
require "letters/core_ext"

module Letters
  def self.object_for_diff=(object)
    @@object = object
  end

  def self.object_for_diff
    @@object if defined?(@@object)
  end
end

class Array
  include Letters::CoreExt
end

class Hash
  include Letters::CoreExt
end

class String
  include Letters::CoreExt
end

class NilClass
  include Letters::CoreExt
end

# class Object
  # include Letters::CoreExt
# end
