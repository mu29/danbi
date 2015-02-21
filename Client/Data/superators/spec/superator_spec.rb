require 'lib/superators'

describe "The 'superator' macro" do
  
  it "should allow two superators to begin with the first 'real' operator" do
    superatored = Class.new do
      superator("--") { throw :superator_dash_dash  }
      superator("-~") { throw :superator_dash_tilde }
    end
    lambda { superatored.new() -- Object.new }.should throw_symbol(:superator_dash_dash)
    lambda { superatored.new() -~ Object.new }.should throw_symbol(:superator_dash_tilde)
  end
  
  it "should raise an error when the 'real' operator isn't a valid Ruby operator" do
    lambda do
      Class.new do
        superator('x--') {}
      end
    end.should raise_error
  end

  it "should raise a NameError when a superator is defined for a class that did not have the 'real' operator but the 'real' operator is used" do
    superatored = Class.new do
      superator('**--') {}
    end
    lambda do
      superatored.new ** Object.new
    end.should raise_error(NameError)
  end

  it "should be callable on a Class instance (e.g. on 'self' in a class definition)" do
    Class.new.should respond_to('superator')
    x = Class.new do
      self.class.superator("-~+~-") { throw :class_superator }
    end
    lambda { x -~+~- Object.new }.should throw_symbol(:class_superator)
    lambda { x.new() -~+~- Object.new }.should raise_error
  end
  
  it "should work when defined in an eigenclass" do    
    victim = Object.new
    class << victim
      superator('<<~~') { throw :eigenclass }
    end
    lambda { victim <<~~ "monkey" }.should throw_symbol(:eigenclass)
  end
  
  it "should preserve the old 'real' operator" do
    victim = Class.new do
      def <<(_)
        throw :original_method
      end
      superator('<<~~') { throw :superator }
    end.new
    lambda { victim <<   Object.new }.should throw_symbol(:original_method)
    lambda { victim <<~~ Object.new }.should throw_symbol(:superator)
    
  end

  # This one is going to be very difficult to implement. method_added() maybe?
  it "should work even when the superator's 'main' method is redefined after the superator macro" do
    victim = Class.new do
      def <(_) throw :first end
      superator("<~~") { throw :superator }
      def <(_) throw :last end
    end
    lambda { victim.new()  <  Object.new }.should throw_symbol(:last)
    lambda { victim.new() <~~ Object.new }.should throw_symbol(:superator)
  end
  
  it "should allow the 'real' operator to be called within the superator definition" do
    victim = "Super"
    class << victim
      superator "++" do |operand|
        upcase + operand.upcase
      end
      superator "-~+~-" do |operand|
        self + operand
      end
    end
    (victim ++ "ators").should == "SUPERATORS"
    lambda { victim -~+~- "man" }.should_not raise_error
  end
  
end

describe "Defined binary superators" do
  
  it "should be available to subclasses" do
    superclass = Class.new do
      superator("<<--") { throw :superclass }
    end
    lambda { Class.new(superclass).new <<-- "Foobar" }.should throw_symbol(:superclass)
  end
  
  it "should be overridable in subclasses" do
    parent = Class.new do
      superator("<~") { throw :parent }
    end
    
    child = Class.new(parent) do
      superator("<~") { throw :child }
    end
    
    lambda { parent.new() <~ Object.new }.should throw_symbol(:parent)
    lambda { child.new()  <~ Object.new }.should throw_symbol(:child)
  end
  
  it "should redefine an already-defined superator of the same class" do
    lambda do
      Class.new do
        superator("<---") { throw :first }
        superator("<---") { throw :last  }
      end.new <--- Object.new
    end.should throw_symbol(:last)
  end

end

describe "The superator_send method" do
  
  it "should execute the block within the object's instance (so self is the instance, not the class)" do
    Class.new do
      superator "-+-" do |other|
        self.should_not be_kind_of(Class)
      end
    end
  end

  it "should receive the proper arguments" do
    x = Class.new do
      superator("-+-+~++~") {}
    end
    victim, operand = x.new, "a clue"
    victim.should_receive(:superator_send).once.with("-+-+~++~", operand)
    victim -+-+~++~ operand
  end
  
  it "should exist on an Object instance" do
    Object.new.should respond_to(:superator_send)
  end
  
  it "should raise NameError if an invalid superator is given" do
    lambda do
      Object.new.superator_send("17BB&DB & !!  @", Object.new.extend(SuperatorFlag))
    end.should raise_error(NameError)
  end

end

describe "The respond_to_superator? method" do
  
  it "should be available on all objects" do
    Object.new.should respond_to(:respond_to_superator?)
  end
  
  it "should return true if a superator was defined for the object's class" do
    Class.new do
      superator("<--") {}
    end.new.respond_to_superator?("<--").should be_true
  end
  
  it "should return true if a superator was defined for the object's superclass" do
    parent = Class.new do
      superator("<=~~") {}
    end
    Class.new(parent) {}.new.respond_to_superator?("<=~~").should be_true
  end
  
  it "should return false or nil if a superator was not defined" do
    result = Class.new.new.respond_to_superator?("<" + ("-" * 100))
    (!! result).should be_false
  end
  
  it "should return false for arguments only similar to (not the same as) the defined superator(s)" do
    labrat = Class.new do
      superator("<" + ('~' * 10)) {}
    end.new
    (!! labrat.respond_to_superator?('<' + ('~' * 11))).should be_false
    (!! labrat.respond_to_superator?('<' + ('~' *  9))).should be_false
  end
  
end

describe "The undef_superator method" do
  
  it "should properly delete a superator" do
    klass = Class.new do
      superator("<----") {}
    end
    lambda do
      obj = klass.new
      obj.undef_superator "<----"
      obj <---- Object.new
    end.should raise_error(NameError)
  end
  
  it "should make respond_to_superator?() return false" do
    sup = "<<---"
    klass = Class.new do
      superator(sup) {}
    end
    obj = klass.new
    obj.undef_superator sup
    obj.respond_to_superator?(sup).should be_false
  end
  
end

describe "The monkey patch" do
  
  it "should create a superators attr_reader" do
    Object.new.should     respond_to(:superator_queue)
    Object.new.should_not respond_to(:superator_queue=)
  end
  
end

describe "The defined_superators() method" do
  
  it "should return an array of superator Strings when called on an object" do
    sups = %w"-- ++ +- -+"
    klass = Class.new do
      sups.each do |sup|
        superator(sup) {}
      end
    end
    defined = klass.new.defined_superators
    
    defined.should be_kind_of(Array)
    defined.size.should == sups.size
    sups.each { |sup| defined.should include(sup) }
  end
  
  it "should include superators defined in a superclass" do
    parent = Class.new do
      superator("--") {}
    end
    Class.new(parent).new.defined_superators.should include("--")
  end
  
end

describe "The 'real' operator finding algorithm" do
  
  it "should work with minus and unary negation" do
    real_operator_from_superator("---").should == "-"
  end
  
  it "should work with plus and unary plus" do
    real_operator_from_superator("+++").should == "+"
  end
  
  it "should return nil when given only unary tildes" do
    real_operator_from_superator("~~~").should be_nil
  end
  
  it "should work properly with the operators that are expanded versions of other operators" do
    real_operator_from_superator("<<--").should == "<<"
    real_operator_from_superator("<~~-").should == "<"
    real_operator_from_superator("**+~").should == "**"
    real_operator_from_superator("*+~~").should == "*"
    real_operator_from_superator("<=~~").should == "<="
    real_operator_from_superator(">=+-").should == ">="
    real_operator_from_superator("=~~~").should == "=~"
    real_operator_from_superator("<=>+").should == "<=>"
    real_operator_from_superator("===+").should == "==="
    real_operator_from_superator("==+-").should == "=="
  end
end

describe "Superator method en-/decoding" do
  
  before do
    @uses = { "<<~~"  => "60_60__126__126",
             "<=>~"   => "60_61_62__126",
             "----"   => "45__45__45__45",
             "+-~+-~" => "43__45__126__43__45__126" }
  end
  
  it "should return the same value after encoding and decoding" do
    @uses.keys.each do |operator|
      superator_decode(superator_encode(operator)).should == operator
    end
  end
  
  it "should encode binary superators properly" do
    @uses.each_pair { |key, value| superator_encode(key).should == value }
  end
  
  it "should decode binary superators properly" do
    @uses.each_pair { |key, value| superator_decode(value).should == key }
  end
  
  it "should create proper method definition name" do
    op = "|+-"
    superator_definition_name_for(op).should =~ /#{superator_encode(op)}$/
  end
  
  it "should be containable in a method definition" do
    lambda do
      eval ":jay_#{superator_encode("<<+~--")}"
    end.should_not raise_error(SyntaxError)
  end 
  
end

describe "A superator's arguments" do
  # These specs are included for someone to potentially fix. Their failing
  # constitutes a bug, though there's no clear way to implement this.

  # These are types that can have no eigenclass. One way to store Kernel#caller
  # stacktraces against the Fixnum value on which the unary methods were executed.
  it "should allow a Fixnum as an operand" # This *MAY* never work
  it "should allow a Symbol as an operand"
  it "should allow true as an operand"
  it "should allow false as an operand"
  it "should allow nil as an operand"
  
end
