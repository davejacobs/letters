require "letters/core_ext"

module Letters
  def self.patch!(obj)
    case obj
    when Class
      obj.instance_eval do
        include Letters::CoreExt
      end
    when Object
      obj.extend Letters::CoreExt
    end
  end
end
