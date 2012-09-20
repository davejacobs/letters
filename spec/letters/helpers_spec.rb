require "spec_helper"

module Letters
  describe Helpers do
    let(:hash) { Hash.new }

    describe ".diff" do
      it "returns the difference between two arrays" do
        array1 = [1, 2, 3]
        array2 = [3, 4, 5]
        Helpers.diff(array1, array2).should == {
          removed: [1, 2],
          added: [4, 5]
        }
      end

      it "returns the difference between two hashes" do
        hash1 = { a: "foo", b: "bar" }
        hash2 = { b: "baz", c: "bat" }

        Helpers.diff(hash1, hash2).should == {
          removed: { a: "foo" },
          added: { c: "bat" },
          updated: { b: "baz" }
        }
      end

      it "returns the difference between two sets" do
        set1 = Set.new([1, 2, 3])
        set2 = Set.new([3, 4, 5])
        Helpers.diff(set1, set2).should == {
          removed: [1, 2],
          added: [4, 5]
        }
      end

      it "returns the difference between two strings" do
        string1 = "Line 1\nLine 2" 
        string2 = "Line 1 modified\nLine 2\nLine 3"
        Helpers.diff(string1, string2).should == {
          removed: ["Line 1"],
          added: ["Line 1 modified", "Line 3"]
        }
      end

      it "returns the difference between two objects of the same hierarchy" do
        DiffableClass = Class.new do
          attr_accessor :vals

          def initialize(vals)
            self.vals = vals
          end

          def -(other)
            vals - other.vals
          end
        end

        dc1 = DiffableClass.new([1, 2, 3])
        dc2 = DiffableClass.new([3, 4, 5])
        Helpers.diff(dc1, dc2).should == {
          removed: [1, 2],
          added: [4, 5]
        }
      end

      it "throws an exception if the objects are not of the same type" do
        lambda do
          Helpers.diff(Object.new, Hash.new)
        end.should raise_error
      end
    end

    describe ".awesome_print" do
      it "outputs the YAML representation of the object then returns the object" do
        Helpers.ap(hash).should == "{}"
      end
    end

    describe ".pretty_print" do
      it "outputs the pretty-print representation of the object and then returns the object" do
        Helpers.pp(hash).should == "{}\n"
      end
    end

    describe ".xml" do
      it "outputs the XML representation of the object and then returns the object" do
        Helpers.xml(hash).should == "<opt></opt>\n"
      end
    end

    describe ".yaml" do
      it "outputs the YAML representation of the object and then returns the object" do
        Helpers.yaml(hash).strip.should == "--- {}"
      end
    end
  end
end
