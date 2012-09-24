require "spec_helper"

module Letters
  describe "time formats" do
    it "allows for easy manipulation of timestamp displays" do
      Time.utc(2012, "jan", 1, 13, 15, 1).tap do |time|
        time.to_s(:millis).should == "01/01/2012 13:15:01:000"
      end
    end
  end
end
