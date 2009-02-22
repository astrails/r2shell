module R2shell
  class Command
    attr_reader :cmd
    def initialize(cmd)
      @cmd = cmd
    end

    def result
      if $TEST
        puts "RUN: #{@cmd}" unless @result
      end
      @result ||= %x{#{@cmd}}
    end

    alias :to_s :result
    
    def to_lines
      result.split("\n")
    end

    def |(other)
      if Command === other
        # TODO: assert didn't run
        Command.new(@cmd + ' | ' + other.cmd)
      else
        result | other
      end
    end
    
    def execute
      if $TEST
        puts "EXEC: #{@cmd}" unless @result
      end
      # TODO: assert didn't run
      system @cmd
    end
    
    def method_missing(*args)
      to_s.send(*args)
    end
  end
end
