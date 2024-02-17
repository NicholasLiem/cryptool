TOTAL_ASCII = 256

def encrypt_data(data, key)
  plain_text = data
  plain_text_length = plain_text.length
  key_length = key.length

  result = ""
  key_idx = 0
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
  result
end

puts(encrypt_data('B$%E$!%#A123##'.upcase, '%!&01#'))