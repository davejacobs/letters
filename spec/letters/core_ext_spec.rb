require "spec_helper"

module Letters
  describe CoreExt do
    let(:hash) { Hash.new }

    before do
      @old_dir = Dir.getwd
      FileUtils.mkdir_p "tmp"
      Dir.chdir "tmp"
    end

    after do
      Dir.chdir @old_dir
      FileUtils.rm_rf "tmp"
    end

    it "all letter methods but #e and #n return the original object" do
      # Prevent output and debugging
      Helpers.should_receive(:call_debugger).any_number_of_times
      $stdout.should_receive(:puts).any_number_of_times
      hash.should_receive(:system).any_number_of_times
      Helpers.should_receive(:change_safety).any_number_of_times

      ("a".."z").to_a.reject do |letter|
        letter =~ /[ejn]/
      end.select do |letter|
        hash.respond_to? letter
      end.each do |letter|
        hash.send(letter).should == hash
      end

      # Methods that can take a block
      hash.j { nil }.should == hash
      hash.p { nil }.should == hash
    end

    describe "#a (assert)" do
      it "jumps into the receiver's calling context" do
        lambda do
          [1, 2, 3].a { count }
        end.should_not raise_error
      end

      it "raises a Letters::AssertionError if the block returns false" do
        lambda do
          [1, 2, 3].a { count > 3 } 
        end.should raise_error(Letters::AssertionError)
      end

      it "raises a Letters::AssertionError if the block returns nil" do
        lambda do
          [1, 2, 3].a { nil }
        end.should raise_error(Letters::AssertionError)
      end

      it "does nothing if the block returns a truthy value" do
        [1, 2, 3].a { count < 4 }.should == [1, 2, 3]
      end
    end

    describe "#c (callstack)" do
      it "outputs the current call trace then returns the object" do
        $stdout.should_receive(:puts).with kind_of String
        hash.c
      end
    end

    describe "#d (debug)" do
      it "enters the debugger and then returns the object" do
        Helpers.should_receive(:call_debugger)
        hash.d
      end
    end

    describe "#d1, #d2 (smart object diff)" do
      it "outputs the difference between two arrays" do
        arr1, arr2 = [1, 2, 3], [3, 4, 5]
        expected_diff = Helpers.diff(arr1, arr2)
        $stdout.should_receive(:puts).with(expected_diff.awesome_inspect).once

        arr1.d1.should == arr1
        arr2.d2.should == arr2
      end
    end

    describe "#e (empty check)" do
      it "raises an error if the receiver is empty" do
        lambda { "".e }.should raise_error(EmptyError)
      end

      it "does nothing if the receiver is not empty" do
        lambda { "string".e }.should_not raise_error
        "string".n.should == "string"
      end
    end

    describe "#f (file)" do
      describe "when no filename or output format are given" do
        it "writes the object as YAML to a file named 'log'" do
          File.exist?("log").should_not be_true
          hash.f
          File.exist?("log").should be_true
          File.read("log").should == hash.to_yaml
        end
      end

      describe "when a file name, but no output format is given" do
        it "writes the object as YAML to the named file" do
          hash.f(:name => "object")
          File.exist?("object").should be_true
          File.read("object").should == hash.to_yaml
        end
      end

      describe "when an output format, but no file name is given" do
        it "writes the object as that format to a file named 'log'" do
          hash.f(:format => :ap)
          File.exist?("log").should be_true
          File.read("log").chomp.should == hash.awesome_inspect
        end
      end
    end

    describe "#j (jump)" do
      it "jumps into the object's context" do
        a = nil
        hash.j { a = count }
        a.should == 0
      end

      it "allows for IO, even in object context" do
        $stdout.should_receive(:puts).with(0)
        hash.j { puts count }
      end
    end

    describe "#l (log)" do
      it "logs the object if a logger is present and then returns the object" do
        logger = double 'logger'
        logger.should_receive(:info).with(hash.to_yaml)
        hash.should_receive(:logger).and_return(logger)
        hash.l
      end

      it "prints an warning if a logger is not present and then returns the object" do
        $stdout.should_receive(:puts).with("[warning] No logger available")
        hash.l
      end

      it "logs the object if a logger is present and then returns the object" do
        logger = double 'logger'
        logger.should_receive(:info).never
        logger.should_receive(:error).with(hash.to_yaml)
        hash.should_receive(:logger).and_return(logger)
        hash.l(:level => "error")
      end
    end

    describe "#n (nil check)" do
      it "raises an error if the receiver is nil" do
        lambda { nil.n }.should raise_error(NilError)
      end

      it "does nothing if the receiver is not nil" do
        lambda { hash.n }.should_not raise_error
      end
    end

    describe "#p (print)" do
      describe "when no format is given" do
        it "writes the object as awesome_print to STDOUT" do
          $stdout.should_receive(:puts).with(hash.awesome_inspect)
          hash.p
        end
      end

      describe "when a format is given" do
        it "writes the object as that format to STDOUT" do
          $stdout.should_receive(:puts).with(hash.to_yaml)
          hash.p(:format => :yaml)
        end
      end

      describe "when a block is given" do
        it "write the result of the block, executed in the object's context" do
          $stdout.should_receive(:puts).with(hash.length.awesome_inspect)
          hash.p { length }.should == hash
        end
      end
    end

    describe "#r (ri)" do
      it "displays RI information for the receiver's class, if available" do
        hash.should_receive(:system).with("ri Hash")
        hash.r
      end

      it "can narrow its scope to a single method" do
        hash.should_receive(:system).with("ri Hash#new")
        hash.r(:new)
      end
    end

    describe "#s (safety)" do
      it "without argument, bumps the safety level by one" do
        Helpers.should_receive(:change_safety).with(1)
        hash.s
      end

      it "bumps the safety level to the specified level if possible" do
        Helpers.should_receive(:change_safety).with(4)
        hash.s(4)
      end

      it "throws an exception if the specified level is invalid" do
        # Simulate changing safety level from higher level
        Helpers.should_receive(:change_safety).with(3).and_raise
        lambda do
          hash.s(3)
        end.should raise_error
      end
    end

    describe "#t (taint object)" do
      it "marks the receiver as tainted" do
        lambda do
          hash.t
        end.should change { hash.tainted? }.from(false).to(true)
      end
    end

    describe "#u (taint object)" do
      it "marks the receiver as tainted" do
        hash.taint
        lambda do
          hash.u
        end.should change { hash.tainted? }.from(true).to(false)
      end
    end
  end
end
