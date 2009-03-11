require 'ruby2ruby'
require 'parse_tree'
require 'parse_tree_extensions'
require 'r2shell/command'
require 'r2shell/shell'
require 'r2shell/rewriter'

module R2shell

  # run block with shell commands support
  def self.with_shell_commands(&block)
    exp = block.to_sexp.last
            if $TEST
              puts "exp:"
              pp exp
              puts "-"*20
            end
            
    exp = Rewriter.new.process2(exp)

            if $TEST
              puts "exp2:"
              pp exp
              puts "-"*20
            end
            
    ruby = Ruby2Ruby.new.process(exp)
            if $TEST
              puts "ruby:\n#{ruby}"
              puts "-"*20
            end
    Shell.new.instance_eval ruby
  end
end

def R2shell(&block)
  R2shell.with_shell_commands(&block)
end
