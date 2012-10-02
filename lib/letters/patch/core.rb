require "letters/patch"
require "set"

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
