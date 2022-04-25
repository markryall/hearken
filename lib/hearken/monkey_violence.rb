# frozen_string_literal: true

class String
  def from_home
    "#{File.expand_path("~")}/#{self}"
  end

  def escape(char)
    gsub(char) { "\\#{char}" }
  end

  def escape_all(chars)
    chars.inject(self) { |s, t| s.escape t }
  end

  def escape_for_sh
    escape_all " `';&!()$".scan(/./)
  end

  def escape_for_sh_quoted
    escape "`"
  end
end
