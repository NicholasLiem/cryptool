module Utils
  extend ActiveSupport::Concern

  class_methods do
    def sanitize_text(text)
      text.gsub(" ", "").upcase
    end

    def is_letter_and_upcase(char)
      c.ord >= 65 && c.ord <= 90
    end
  end
end
