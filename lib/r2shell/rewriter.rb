require 'rewrite'
require 'ruby2ruby'

module R2shell
  class Rewriter < SexpProcessor
    def process(exp)
      puts "EXP:\t#{exp.inspect}"
      super
    end
    
    def process_block(exp)
      # puts "BLOCK:"
      # pp exp
      # puts "/BLOCK"
      exp.shift
      s(:block, *exp.map{|s| process2(s)})
    ensure
      exp.clear
    end
    
    private
    def process2(exp)
      return exp unless exp.is_a?(Array)
      
      case exp.first
      when :fcall, :call, :vcall
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
      when :if
        [:if,
          process2(exp[1]),
          process2(exp[2])
        ]
      when :for
        # puts "===== FOR:"
        # pp exp
        # puts "=========="
        [:for, process(exp[1]), process(exp[2]), process2(exp[3])]
      else
        process(exp)
      end
    end
    
    def gensym
      :"__#{Time.now.to_i}#{rand(100000)}__"
    end
    
  end
end