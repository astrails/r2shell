require 'ruby2ruby'

module R2shell
  class Rewriter < SexpProcessor



    def process(exp)
      puts "EXP:\t#{exp.inspect}"

      return exp unless exp.is_a?(Array)
      
      case exp.first
      when :block
        exp.map{|s| process2(s)}
      when :iter, :for
        last = exp.pop
        exp.map{|s| process(s)} << process2(last)
      else
        super
      end
    end
    
    def process2(exp)
      return process(exp) unless exp.is_a?(Array)
      
      return process(exp) if [:block, :iter].include?(exp.first)
      
      puts "EXP2:\t#{exp.inspect}" if $TEST
      
      autoexec(exp)
    end
    
    private
    
    def gensym
      :"__#{Time.now.to_i}#{rand(100000)}__"
    end

    def autoexec(exp)
      var = gensym
      val = process(exp)
      s(:block,
        s(:dasgn_curr, var, val),
        s(:if,
          s(:call, s(:dvar, var),:is_a?, s(:array, s(:colon2, s(:const, :R2shell), :Command))),
          s(:call, s(:dvar, var), :execute),
          s(:dvar, var)
        )
      )
    end
    
    
  end
end