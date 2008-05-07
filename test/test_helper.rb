require File.dirname(__FILE__) + '/../lib/prag_dave_testing.rb'

require 'stringio'

module Helper
  
  def run_test_and_catch_stderr(&block)
    olderr = $stderr
    err = StringIO.new
    $stderr = err
    begin
      failures  = TestResultsGatherer.instance.instance_eval { @failures }
      successes = TestResultsGatherer.instance.instance_eval { @successes }
      yield
      TestResultsGatherer.instance.instance_eval { @failures = failures }
      TestResultsGatherer.instance.instance_eval { @successes = successes}
    rescue StandardError => e
      return e.message
    ensure
      $stderr = olderr
    end
    err.string
  end
  
  alias  run run_test_and_catch_stderr
  
  def debug_integration
    return unless defined? RAILS_ROOT
    puts "\n ++++ methods:\n"
    puts methods
    puts "\n ++++ variables:\n"
    puts instance_variables
    puts "\n ++++ request:\n"
    puts request.instance_variables
    puts "\n ++++ response:\n"
    puts response.instance_variables
    puts "\n ++++ assigns:\n"
    puts assigns
  end
  
end

include Helper