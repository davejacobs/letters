class ActiveRecord
  class Base; end
end

class ActionController
  class Base; end
end

class ActionMailer
  class Base; end
end

describe "Rails patches" do
  it "adds methods to each of the specified core classes" do
    require "letters/patch/core"

    [ActiveRecord::Base,
     ActionController::Base,
     ActionMailer::Base].each do |klass|
      klass.new.should respond_to(:a)
    end
  end
end
