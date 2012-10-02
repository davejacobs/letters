module Letters
  def self.object_for_diff=(object)
    @@object = object
  end

  def self.object_for_diff
    @@object if defined?(@@object)
  end
end
