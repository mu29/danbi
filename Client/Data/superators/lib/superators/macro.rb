module SuperatorMixin
  
  BINARY_RUBY_OPERATORS = %w"** * / % + - << >> & | ^ <=> >= <= < > === == =~"
  UNARY_RUBY_OPERATORS  = %w"-@ ~@ +@"
  
  BINARY_OPERATOR_PATTERN = BINARY_RUBY_OPERATORS.map { |x| Regexp.escape(x) }.join "|"
  UNARY_OPERATOR_PATTERN  =  UNARY_RUBY_OPERATORS.map { |x| Regexp.escape(x) }.join "|"
  UNARY_OPERATOR_PATTERN_WITHOUT_AT_SIGN = UNARY_OPERATOR_PATTERN.gsub '@', ''
  
  VALID_SUPERATOR = /^(#{BINARY_OPERATOR_PATTERN})(#{UNARY_OPERATOR_PATTERN_WITHOUT_AT_SIGN})+$/
  
  def superator_send(sup, operand)
    if respond_to_superator? sup
      __send__ superator_definition_name_for(sup), operand
    else
      raise NoMethodError, "Superator #{sup} has not been defined on #{self.class}"
    end
  end
  
  def respond_to_superator?(sup)
    respond_to? superator_definition_name_for(sup)
  end
  
  def defined_superators
    methods.grep(/^superator_definition_/).map { |m| superator_decode(m) }
  end
  
  protected
  
  def superator(operator, &block)
    raise ArgumentError, "block not supplied" unless block_given?
    raise ArgumentError, "Not a valid superator!" unless superator_valid?(operator)
    
    real_operator = real_operator_from_superator operator
    
    class_eval do
      # Step in front of the old operator's dispatching.
      alias_for_real_method = superator_alias_for real_operator
      
      if instance_methods.include?(real_operator) && !respond_to_superator?(operator)
        alias_method alias_for_real_method, real_operator
      end
      
      define_method superator_definition_name_for(operator), &block
      
      # When we get to the method defining, we have to know whether the superator had to be aliased
      # or if it's new entirely.
      define_method(real_operator) do |operand|
        if operand.kind_of?(SuperatorFlag) && operand.superator_queue.any?
          sup = operand.superator_queue.unshift(real_operator).join
          operand.superator_queue.clear
          
          superator_send(sup, operand)
        else
          # If the method_alias is defined
          if respond_to? alias_for_real_method
            __send__(alias_for_real_method, operand)
          else
            raise NoMethodError, "undefined method #{real_operator} for #{operand.inspect}:#{operand.class}"
          end
        end
      end
      
    end
    
    def undef_superator(sup)
      if respond_to_superator?(sup)
        real_operator = real_operator_from_superator sup
        real_operator_alias = superator_alias_for sup
        
        (class << self; self; end).instance_eval do
          undef_method superator_definition_name_for(sup)
          if respond_to? real_operator_alias
            alias_method real_operator, real_operator_alias if defined_superators.empty?
          else
            undef_method real_operator
          end
        end
      else
        raise NoMethodError, "undefined superator #{sup} for #{self.inspect}:#{self.class}"
      end
    end
  end
  
  private
  
  def superator_encode(str)
    tokenizer = /#{BINARY_OPERATOR_PATTERN}|#{UNARY_OPERATOR_PATTERN_WITHOUT_AT_SIGN}/
    str.scan(tokenizer).map { |op| op.split('').map { |s| s[0] }.join "_" }.join "__"
  end
  
  def superator_decode(str)
    tokens = str.match /^(superator_(definition|alias_for))?((_?\d{2,3})+)((__\d{2,3})+)$/
    #puts *tokens
    if tokens
      (tokens[3].split("_" ) + tokens[5].split('__')).reject { |x| x.empty? }.map { |s| s.to_i.chr }.join
    end
  end
  
  def real_operator_from_superator(sup)
    sup[/^#{BINARY_OPERATOR_PATTERN}/]
  end
  
  def superator_alias_for(name)
    "superator_alias_for_#{superator_encode(name)}"
  end
  
  def superator_definition_name_for(sup)
    "superator_definition_#{superator_encode(sup)}"
  end
  
  def superator_valid?(operator)
    operator =~ VALID_SUPERATOR
  end
  
end

module SuperatorFlag;end