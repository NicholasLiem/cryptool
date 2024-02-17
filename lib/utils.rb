module Utils
  module_function

  def sanitize_text(text)
    text.gsub(" ", "").upcase
  end

  def is_letter_and_upcase(char)
    char.ord >= 65 && char.ord <= 90
  end
end
