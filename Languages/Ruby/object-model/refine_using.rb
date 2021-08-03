module StringExt
  # refine String::to_alphanumeric:
  # make it useable only when "using StringExt".
  refine String do
    def to_alphanumeric()
      gsub(/[^\w\s]/, '')
    end
  end
end

module StringStuff
  using StringExt
  def utils()
      print "sha256 is not? useful.".to_alphanumeric
  end

  module_function :utils
end

StringStuff.utils()