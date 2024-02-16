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
    # Reset if it achieves max
    if (keyIdx == keyLength)
      keyIdx = 0
    end

    tempChar = plainText[i]
    keyChar = key[keyIdx]

    # Check if it is a letter and upcase
    if (isLetterAndUpperCase(tempChar))
      plainInt = tempChar.ord - 65
      keyInt = keyChar.ord - 65


      # NewChar int
      cipherInt = (plainInt + keyInt) % 26 + 65
      cipherChar = cipherInt.chr

      # Add to result
      result = result + cipherChar

      # Increment
      keyIdx = keyIdx + 1
    
    # If not, leave it as it is
    else
      result = result + tempChar
    end
  end
  return result
end


def decrypt(str, key)
  chipherText = str.upcase
  key = key.upcase
  chipherTextLength = chipherText.length
  keyLength = key.length

  result = ""
  keyIdx = 0
  for i in 0..(chipherTextLength-1)    
    # Reset if it achieves max
    if (keyIdx == keyLength)
      keyIdx = 0
    end

    tempChar = chipherText[i]
    keyChar = key[keyIdx]

    # Check if it is a letter and upcase
    if (isLetterAndUpperCase(tempChar))
      chipherInt = tempChar.ord - 65
      keyInt = keyChar.ord - 65


      # NewChar int
      plainInt = (chipherInt - keyInt) % 26 + 65
      plainChar = plainInt.chr

      # Add to result
      result = result + plainChar

      # Increment
      keyIdx = keyIdx + 1
    
    # If not, leave it as it is
    else
      result = result + tempChar
    end
  end
  return result
end

key = "selat sunda"
str = "Dinas Pendidikan Kota Ternate meminta kepada pihak sekolah dan orang tua siswa untuk jenjang pendidikan SD dan SMP se-Kota Ternate untuk melarang para siswa membawa permainan lato-lato yang sedang tren itu ke sekolah, karena akan mengganggu kegiatan belajar mengajar yang dinilai berbahaya sehingga mengantisipasi kecelakaan bagi anak di daerah itu"
cip = "VMYAL HYAGIVMVAG CIGD TWVYAMW GRPIFXL KXHUQD PALLK LWEBOAZ HLN HJUAJ TME DILOU HQTMO UEGBUAJ PWROIWAENQ SV HLN LEJ FH-KGXL TXJHNWE MREUD EYYDRSRR PTJU FLSOE XEFTUJD PWVXABFUA OALS-WAMG SNQG KIOAGY NEHN AXF KX KYXRLSL, VAKWHN DKSR XEGYANQGYY VEZAUGDN TIWACSL ZHNYEUAK QUAJ DARTLTA VRUBSLLYT KYULNYKL MXFANQTAWTPTKC XHCWPLKTSH ODGA EYAD VC QDEJES IMM"

key = prepareKey(key)
# str = preparePlainText(str)

# puts encrypt(str, key)
# puts decrypt(cip, key)

