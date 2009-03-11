
module R2shell
  class Rewriter < SexpProcessor



    def process(exp)
      puts "EXP:\t#{exp.inspect}" if $TEST

      return exp unless exp.is_a?(Array)
      
      case exp.first
      when :block
        # for block all the values except for the last are lost, so we need to exec them
        last = exp.pop
        res = exp.map{|s| process2(s)}
        res << process(last)
      when :iter, :for
        last = exp.pop
        exp.map{|s| process(s)} << process2(last)
      when :if
        res = [exp.shift]
        res << process2(exp.shift, false)
        res + exp.map {|s| process(s)}
      else
        super
      end
    end
    
    def process2(exp, check_errors = true)
      return exp unless exp.is_a?(Array)
      
      puts "EXP2:\t#{exp.inspect}" if $TEST
      
      autoexec(process(exp), check_errors)
    end
    
    private
    
    def gensym
      :"__#{Time.now.to_i}#{rand(100000)}__"
    end

    def autoexec(val, check_errors = true)
      var = gensym
      s(:block,
        s(:lasgn, var, val),
        s(:if,
          s(:call, s(:lvar, var),:is_a?, s(:arglist, s(:colon2, s(:const, :R2shell), :Command))),
          s(:call, s(:lvar, var), :execute, s(:arglist, s(check_errors ? :true : :false))),
          s(:lvar, var)
        )
      )
    end
    
  end
end
