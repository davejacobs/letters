class ActiveRecord
  class Base
    def -(other)
      self
    end
  end
end

class ActionController
  class Base; end
end

class ActionMailer
  class Base; end
end

describe "Rails patches" do
  before do
    require "letters/patch/rails"
  end

  it "adds methods to each of the specified core classes" do
    [ActiveRecord::Base,
     ActionController::Base,
     ActionMailer::Base].each do |klass|
      klass.new.should respond_to(:a)
    end
  end

  it "allows d1/d2 pairs" do
    $stdout.should_receive(:puts)

    lambda do
      ActiveRecord::Base.new.d1
      ActiveRecord::Base.new.d2
    end.should_not raise_error
  end
end
