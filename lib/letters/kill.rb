module Letters
  def self.kill_count=(count)
    @@kill_count = count
  end

  def self.kill_count
    @@kill_count if defined?(@@kill_count)
  end
end
