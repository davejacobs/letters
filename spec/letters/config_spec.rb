require "spec_helper"

module Letters
  describe "configuration" do
    let(:hash) { { a: "b" } }

    before do
      Letters.config do
        f :format => "pp"
      end
      File.exist?("log").should be_false
    end

    after do
      FileUtils.rm "log"
    end

    describe ".config" do
      it "allows default argument configuration" do
        hash.f
        File.read("log").should == hash.pretty_inspect
      end
    end

    describe ".reset_config!" do
      it "clears out the config hash" do
        Letters.reset_config!
        hash.f
        File.read("log").should == hash.to_yaml
      end
    end
  end
end
