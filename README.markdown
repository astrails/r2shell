R2shell
=======

R2shell simplifies writing simple shell-like scripts in ruby.

Dependencies
------------

* Ruby2Ruby
* ParseTree

Install
-------

gem install astrails-r2shell --source http://gems.github.com/

Example
-------

	R2shell do
	  rm "-rf", "/tmp/build-foo"
	  mkdir "-p", "/tmp/build-foo"
	  cd "/tmp/build-foo"
	  wget "http://...../foo.tgz"
	  tar "-zxvf", "foo.tgz"
	  cd "foo"
	  wget "..../foo-patches.tgz"
	  tar "zcf", "foo-patches.tgz"
	  ls("foo-patches").each do |p|
		patch "-i", "foo-patches/#{p}", "-p1"
	  end
	  for target in %w/build docs test install/ do
		make target
	  end
	end
