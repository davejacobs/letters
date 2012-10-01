module Letters
  describe "core patches" do
    it "adds methods to each of the specified core classes" do
      require "letters/patch/core"

      instances = [1, "string", :symbol,
                   /regexp/, [], Set.new,
                   {}, 1..3, nil,
                   true, false] 

      instances.each do |instance|
        instance.should respond_to(:a)
      end
    end
  end
end
