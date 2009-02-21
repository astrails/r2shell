require 'r2shell/shell'
require 'r2shell/rewriter'

module R2shell

  # run block with shell commands support
  def self.with_shell_commands(&block)
    exp = block.to_sexp.last
            puts "exp:"
            pp exp
            puts "-"*20
            
    exp = Rewriter.new.process2(exp)

    puts "exp2:"
    pp exp
    puts "-"*20
            
    ruby = Ruby2Ruby.new.process(exp)
            puts "ruby:\n#{ruby}"
            puts "-"*20
    Shell.new.instance_eval ruby
  end
  
end

def R2shell(&block)
  R2shell.with_shell_commands(&block)
end