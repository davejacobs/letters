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
      Letters.reset_config!
      FileUtils.rm_rf "log"
    end

    describe ".config" do
      it "allows default argument configuration" do
        hash.f
        File.read("log").should == hash.pretty_inspect
      end

      it "allows global default argument configuration" do
        Letters.config do
          all :line_no => true
        end

        $stdout.should_receive(:puts).exactly(4).times
        hash.b
      end

      it "allows specific defaults to override global defaults" do
        Letters.config do
          all :line_no => true
          b :line_no => false
        end

        $stdout.should_receive(:puts).never
        hash.b
      end

      it "allows disabling of all letters" do
        Letters.config do
          all :disable => true
          b :line_no => true
        end

        $stdout.should_receive(:puts).never
        hash.b
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
