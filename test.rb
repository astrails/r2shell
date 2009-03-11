require 'rubygems'
require 'ruby-debug'
require 'pp'
$:.unshift "lib"
require 'r2shell'

$TEST = true

R2shell do
  res = ls("-l")
  echo("abc") | sed("s/b/B/")
  pwd
  cd "/"
  pwd
  puts ls.grep(/mac/)

  if true
    echo "if block"
    puts echo("if block puts")
  end

  echo "if exp" if true
  
  for d in ["/", "/bin"] do
    echo d
    echo "usr#{d}"
  end
  
  for a in [  1, 2, 3] do
    echo "for exp"
  end

  [1, 2, 3].each do
    echo "iter block 1"
    echo "iter block 1"
  end

  [1, 2, 3].each do |x|
    echo "iter block 2 #{x}"
    echo "iter block 2 #{x}"
  end

  [  1, 2, 3].each do
    echo "iter exp 1"
  end

  [  1, 2, 3].each do |x|
    echo "iter exp 2"
  end

  puts ls.grep(/mac/)

end
