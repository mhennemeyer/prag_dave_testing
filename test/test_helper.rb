require '../lib/prag_dave_testing.rb'

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
    ensure
      $stderr = olderr
    end
    err.string
  end
  
  alias  run run_test_and_catch_stderr
  
end

include Helper