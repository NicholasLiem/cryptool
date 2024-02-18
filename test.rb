TOTAL_ASCII = 256

def transposition_cipher(row, col, text)
  matrix = Array.new(row) { Array.new(col, ' ') }
  remainder = (row * col) - text.length
  (1..remainder).each do |_i|
    text += '*'
  end

  # Display Matrix
  # (0..(text.length-1)).each do |i|
  #   cur_row = i / row
  #   cur_col =  i % col
  #   matrix[cur_row][cur_col] = text[i]
  # end
  # matrix.each do |row|
  #   puts row.join(' ')
  # end

  result = ''
  (0..col - 1).each do |j|
    (0..row - 1).each do |i|
      temp_char = text[(col * i) + j]
      result += temp_char
    end
  end

  puts result

  matrix
end

def encrypt_data(data, key)
  plain_text = data
  plain_text_length = plain_text.length
  key_length = key.length

  result = ""
  key_idx = 0

  # Extended Vigenere
  (0..(plain_text_length - 1)).each do |i|
    # Reset if it reaches max
    key_idx = 0 if key_idx == key_length

    temp_char = plain_text[i]
    key_char = key[key_idx]

    plain_int = temp_char.ord
    key_int = key_char.ord

    # NewChar int
    cipher_int = ((plain_int + key_int) % TOTAL_ASCII)
    cipher_char = cipher_int.chr

    # Add to result
    result += cipher_char

    # Increment
    key_idx += 1
  end

  col = key.length
  row = (result.length.to_f / col).ceil
  transposition_cipher(row, col, result)

  result
end

puts(encrypt_data('B$%E$!%#A123##34712BFCIE138ASAWE'.upcase, '%!&01#'))
