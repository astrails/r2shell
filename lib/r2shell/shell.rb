
module R2shell
  class Shell

    def initialize(opts = {})
      @opts = opts
    end

    def sh(sym, *args)
      args = *args unless args.empty?

      Command.new(shelljoin(sym.to_s, *args), @opts)
    end

    def method_missing(sym, *args)
      `which #{sym}`
      super unless $?.to_i == 0

      sh(sym, *args)
    end

    def cd(dir)
      Dir.chdir dir
    end


    ## UTILS

    # shelljoin and shellescape taken form ruby 1.8.7 shellwords (with minor diffs)
    def shelljoin(*cmd)
      cmd.map{|x| shellescape(x.to_s)}.join(" ")
    end

    def shellescape(str)
      # An empty argument will be skipped, so return empty quotes.
      return "''" if str.empty?

      str = str.dup

      # Process as a single byte sequence because not all shell
      # implementations are multibyte aware.
      str.gsub!(/([^A-Za-z0-9_\-.,:\/@\n])/n, "\\\\\\1")

      # A LF cannot be escaped with a backslash because a backslash + LF
      # combo is regarded as line continuation and simply ignored.
      str.gsub!(/\n/, "'\n'")

      return str
    end

  end
end
