require "letters/core_ext"

module Letters
  def self.patch!(klass)
    klass.instance_eval do
      include Letters::CoreExt
    end
  end
end
