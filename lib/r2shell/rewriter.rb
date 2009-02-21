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
      
      autoexec(exp)
    end
    
    private
    
    def gensym
      :"__#{Time.now.to_i}#{rand(100000)}__"
    end

    def autoexec(exp)
      var = gensym
      val = process(exp)
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