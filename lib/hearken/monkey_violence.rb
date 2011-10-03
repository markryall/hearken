class String
  def from_home
    File.expand_path('~')+'/'+self
  end

  def escape char
    gsub(char) { "\\#{char}" }
  end

  def escape_all chars
    chars.inject(self) {|s,t| s.escape t }
  end

  def escape_for_sh
    self.escape_all " `';&!()$".scan(/./)
  end

  def escape_for_sh_quoted
    self.escape '`'
  end
end