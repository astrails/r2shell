module R2shell
  class Command
    attr_reader :command
    def initialize(command)
      @command = command
    end

    def result
      if $TEST
        puts "RUN: #{@command}" unless @result
      end
      @result ||= %x{#{@command}}
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
    
    def execute
      if $TEST
        puts "EXEC: #{@command}" unless @result
      end
      # TODO: assert didn't run
      system @command
    end
    
    def method_missing(*args)
      to_s.send(*args)
    end
  end
end
