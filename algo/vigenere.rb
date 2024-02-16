#!/usr/bin/ruby

def isLetterAndUpperCase(c)
  return c.ord >= 65 && c.ord <= 90
end

def prepareKey(key)
  key = key.gsub(" ", "").upcase
  return key
end

def preparePlainText(plainText)
  plainText = plainText.gsub(" ", "").upcase
  return plainText
end

def encrypt(str, key)
  
  plainText = str.upcase
  key = key.upcase
  plainTextLength = plainText.length
  keyLength = key.length

  result = ""
  keyIdx = 0
  for i in 0..(plainTextLength-1)
    tempChar = plainText[i]
    
    # Reset if it achieves max
    if (keyIdx == keyLength)
      keyIdx = 0
    end

    # If its not letter and uppercase, ignore it
    if (isLetterAndUpperCase(tempChar))


      # Increment
      keyIdx = keyIdx + 1

    end
  
  end

  


  return key
end


def decrypt(str, key)

end

key = "selat sunda"
str = "Dinas Pendidikan Kota Ternate meminta kepada pihak sekolah dan orang tua siswa untuk jenjang pendidikan SD dan SMP se-Kota Ternate untuk melarang para siswa membawa permainan lato-lato yang sedang tren itu ke sekolah, karena akan mengganggu kegiatan belajar mengajar yang dinilai berbahaya sehingga mengantisipasi kecelakaan bagi anak di daerah itu"

key = prepareKey(key)
str = preparePlainText(str)

puts encrypt(str, key)

