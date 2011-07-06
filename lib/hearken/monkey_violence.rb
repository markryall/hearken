class String
  def from_home
    File.expand_path('~')+'/'+self
  end

  def escape char
    gsub(char, "\\#{char}")
  end

  def escape2 char
    split(char).join("\\#{char}")
  end

  def escape_for_sh
    self.escape2("\`").escape(" ").escape2("&").escape2(";").escape("!").escape("(").escape(")").escape2("'")
  end

  def escape_for_sh_quoted
    self.escape2("\`")
  end
end