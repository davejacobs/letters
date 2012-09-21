require "letters/patch"

module Letters
  def self.object_for_diff=(object)
    @@object = object
  end

  def self.object_for_diff
    @@object if defined?(@@object)
  end
end

Letters.patch! Numeric
Letters.patch! Symbol
Letters.patch! String
Letters.patch! Regexp
Letters.patch! Array
Letters.patch! Set
Letters.patch! Hash
Letters.patch! Range
Letters.patch! NilClass
Letters.patch! TrueClass
Letters.patch! FalseClass
