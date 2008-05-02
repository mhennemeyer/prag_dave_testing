module PragDaveTesting
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
end