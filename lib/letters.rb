require "letters/helpers"
require "letters/core_ext"

module Letters
  def self.object_for_diff=(object)
    @@object = object
  end

  def self.object_for_diff
    @@object if defined?(@@object)
  end

  def self.patch!(klass)
    klass.instance_eval do
      include Letters::CoreExt
    end
  end
end

# Letters.patch! Object

Letters.patch! Fixnum
Letters.patch! String
Letters.patch! Array
Letters.patch! Range
Letters.patch! Hash
Letters.patch! NilClass
Letters.patch! TrueClass
Letters.patch! FalseClass
