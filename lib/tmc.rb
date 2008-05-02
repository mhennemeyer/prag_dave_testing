

class TestResultsGatherer
  require 'singleton'
  include Singleton
  
  def initialize
    @failures = @successes = 0
    at_exit { report_test_statistics }
  end
  
  # Report a failure, giving context from the source file that caused it
  def report_failure(message)
    @failures += 1
    file, line = caller(3)[0].split(/:/, 2)
    line = line.to_i
    lines = File.readlines(file)
    line_in_error = lines[line-1]
    comment = find_comment(lines, line-1)

    $stderr.print "\n#{file}:#{line}"
    $stderr.print "—while testing #{@description}" if @description
    $stderr.puts
    $stderr.puts "\t#{comment}" if comment
    $stderr.puts "\tthe code was: \n #{line_in_error.strip}," + "\n"
    $stderr.puts "\tbut #{message}" + "\n"
  end
  
  def report_success
    @successes += 1
  end
  
  def report_test_statistics
    $stderr.puts "\n#{pluralize_test(@successes)} passed, #{pluralize_test(@failures)} failed"
  end
    

  private
  
  LINE_COMMENT = /^\s*#\s*/
    
  # Search back from a line for immediately preceding comments. Skip blank lines,
  # and then accept any consecutive comment lines. We also accept a trailing comment
  # on the line causing the error
  def find_comment(lines, line)
    return $1 if lines[line].sub!(/#\s*(.*)/, '')
      
    end_comment_line = line - 1
    while end_comment_line >= 0 && lines[end_comment_line] =~ /^\s*$/
      end_comment_line -= 1
    end

    return nil if end_comment_line < 0 || lines[end_comment_line] !~ LINE_COMMENT
    
    start_comment_line = end_comment_line
    while start_comment_line > 0 && lines[start_comment_line-1] =~ LINE_COMMENT
      start_comment_line -= 1
    end
    
    lines[start_comment_line..end_comment_line].map {|line| line.sub(LINE_COMMENT, '').strip}.join(" ")
  end

  def pluralize_test(count)
    count == 1 ? "1 test" : "#{count} tests"
  end
end




class ComparisonProxy
  
  # Is this comparison negated? : !=, !~
  def positive_comparison?
    file, line = caller(3)[0].split(/:/, 2)
    line = line.to_i
    lines = File.readlines(file)
    current = lines[line-1]
    !(current =~ /expect\(.*\)\s(!=|!~)/)
  end
  
  # Comparison operators we support and their opposites
  OPERATORS = {}
  [
   [ :">" , :"<=" ],
   [ :">=", :"<"  ],
   [ :"==", :"!=" ],
   [ :"==", :"!=" ],
   [ :"==", :"!=" ]
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
    negated_operator = positive_comparison? && OPERATORS[op] || op
    if @value.send(op, other) && op != negated_operator
      @test_runner.report_success
    else
      actual = @value.inspect
      actual.size < 30 ? (seperator, tab = " ", "") : (seperator, tab = "\n", "\t")
      report = [actual, tab + negated_operator.to_s, other.inspect].join seperator
      @test_runner.report_failure(report)
    end
  end

end

def expect(value)
  ComparisonProxy.new(TestResultsGatherer.instance, value, @__test_description)
end

# Save any instance variables, yield to our block, then restore the instance
# variables. We also save the test description in @__test_description. This is
# tacky, but has the nice side effect of saving and restoring it in nested
# testing blocks
def testing(description)
  ivs = {}
  instance_variables.each do |iv|
    ivs[iv] = instance_variable_get(iv)
  end
  saved = Marshal.dump(ivs)
  @__test_description = description
  yield
  @__test_description = nil
  instance_variables.each { |iv| instance_variable_set(iv, nil) }
  ivs = Marshal.load(saved)
  ivs.each do |iv, value|
    instance_variable_set(iv, value)
  end
end

# Examples of all this in action...

if __FILE__ == $0

  # Regular tests
  expect(1) == 1
  expect(1) < 3
  expect("cat") =~ /[aeiou]/

  # groups of tests
  testing("negative numbers") do
    expect(-3) <= -3
    expect(-1) > -1000
    testing("negative floating point numbers") do
      expect(-3.0) <= -3
    end
  end

  # Transactional instance variables rather than setup()
  @var = "cat"
  expect(@var) =~ /a/
  testing("uppercase version") do
    @var.upcase!
    expect(@var) =~ /A/
    testing("reversed") do 
      @var = @var.reverse
      expect(@var) == "TAC"
    end
    expect(@var) == "CAT"
  end
  expect(@var) =~ /a/  # original value restored
  
  # this comment will annotate the following failed test
  expect(1) == 2
  
  expect(2) == 3  # so will this one
  
  expect(1) != 1  # now this negation thing works:
  
  expect(3) <= 4
  
  expect(1) == 1
  
end
