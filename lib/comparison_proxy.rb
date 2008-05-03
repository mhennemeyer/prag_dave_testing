module PragDaveTesting
  class ComparisonProxy
  
    # Is this comparison not negative? : !=, !~
    def positive_comparison?
      file, line = caller(3)[0].split(/:/, 2)
      current = File.readlines(file)[line.to_i-1]
      !(current =~ /(expect\(.*|^\s*)\)\s*(!=|!~)/)
    end
  
    # Comparison operators we support and their opposites
    OPERATORS = {}
    [
     [ :">" , :"<=" ],
     [ :">=", :"<"  ],
     [ :"==", :"!=" ],
    ].each {|op1, op2| OPERATORS[op1] = op2; OPERATORS[op2] = op1 }

    # Then ones that don't have opposites
    OPERATORS[:"==="] = "not ==="
  
    # the following two are here because the Ruby parser maps a != b and a !~ b 
    # to  !(a == b) and  !(a =~ b). Sigh...
    OPERATORS[:"=="]  = "!="
    OPERATORS[:"=~"]  = "!~"
  
    OPERATORS.keys.each do |comparison_op|
      define_method(comparison_op) do |other|
        __compare(comparison_op, other)
      end
    end
  
    def initialize(test_runner, value, description)
      @test_runner = test_runner
      @value       = value
      @description = description
    end
    
    private
  
    def __compare(op, other)
      negated_operator = (positive_comparison? && OPERATORS[op]) || op
      comparison = @value.send(op, other)
      if (comparison && op != negated_operator) || (!comparison && op == negated_operator)
        @test_runner.report_success
      else
        actual = @value.inspect
        actual.size < 30 ? (seperator, tab = " ", "") : (seperator, tab = "\n", "\t")
        report = [actual, tab + negated_operator.to_s, other.inspect].join seperator
        @test_runner.report_failure(report)
      end
    end

  end
end