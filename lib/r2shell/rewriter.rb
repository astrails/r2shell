require 'ruby2ruby'

module R2shell
  class Rewriter < SexpProcessor



    def process(exp)
      puts "EXP:\t#{exp.inspect}"

      return exp unless exp.is_a?(Array)
      
      case exp.first
      when :block
        exp.map{|s| process2(s)}
      else
        super
      end
    end
    
    def process2(exp)
      return process(exp) unless exp.is_a?(Array)
      
      puts "EXP2:\t#{exp.inspect}"
      
      _process(exp)
      # case exp.first
      # when :fcall, :call, :vcall, :if
      # else
      #   process(exp)
      # end
    end
    
    def autoexec(res)
      res.is_a?(R2shell::Command) ? res.execute : res
    end
    
    private
    
    def gensym
      :"__#{Time.now.to_i}#{rand(100000)}__"
    end

    def _process(exp)
      val = process(exp)
      # [:call, [:const, :R2shell], :autoexec, [:array, val]]
      
      var = gensym
      [:block,
       [:dasgn_curr, var, val],
       [:if,
         [:call,[:dvar, var],:is_a?,[:array,[:colon2, [:const, :R2shell], :Command]]],
         [:call, [:dvar, var], :execute],
         [:dvar, var]
       ]
      ]
    end
    
    
  end
end