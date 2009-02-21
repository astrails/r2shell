require 'rubygems'
require 'ruby-debug'
require 'pp'
$:.unshift "lib"
require 'r2shell'

R2shell do
  echo("abc") | sed("s/b/B/")
  pwd
  cd "/"
  pwd
  puts ls.grep(/mac/)

  for d in ["/", "/bin"] do
    echo d
    echo "usr#{d}"
  end
  
  if true
    echo "if block"
    puts echo("if block puts")
  end

  echo "if exp" if true
  
  for a in [  1, 2, 3] do
    echo "for exp"
  end
end if false

R2shell do
  begin
    if true
      echo 123
    else
      echo 456
    end
    echo 678
  end
  # R2shell.autoexec(:foo)
end
