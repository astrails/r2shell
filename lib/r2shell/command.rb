module R2shell
  class Command
    class ExecutionError < RuntimeError; end
    attr_reader :command
    def initialize(command, opts = {})
      @command = command
      @check_errors = opts[:check_errors]
    end

    def status(check_errors)
      return @status if defined?(@status)

      @status = $?.to_i
      if @check_errors && check_errors
        raise ExecutionError, "Shell command #{@command.inspect} returned #{@status}" unless @status.zero?
      end
      @status = @status.zero?
    end

    def result
      if $TEST
        puts "RUN: #{@command}" unless @result
      end
      @result ||= %x{#{@command}}
      status(@check_errors)
      @result
    end

    alias :to_s :result
    
    def lines
      @lines ||= result.split("\n")
    end

    def each(&block)
      lines.each(&block)
    end
    include Enumerable

    def |(other)
      if Command === other
        # TODO: assert didn't run
        Command.new(@command + ' | ' + other.command)
      else
        result | other
      end
    end
    
    def execute(check_errors = true)
      if $TEST
        puts "EXEC: #{@command}" unless @result
      end
      # TODO: assert didn't run
      system @command
      status(check_errors)
    end
    
    def method_missing(*args)
      to_s.send(*args)
    end
  end
end
