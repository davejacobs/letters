require "letters/patch"

module Letters
  def self.object_for_diff=(object)
    @@object = object
  end

  def self.object_for_diff
    @@object if defined?(@@object)
  end
end

Letters.patch! Fixnum
Letters.patch! String
Letters.patch! Array
Letters.patch! Range
Letters.patch! Hash
Letters.patch! NilClass
Letters.patch! TrueClass
Letters.patch! FalseClass
