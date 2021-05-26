jis = {}
utf = {}

# ASCII Compatible
(0x00..0x7F).each do |i|
  jis["0x#{i.to_s(16).rjust(2, '0')}"] = [i].pack('c*').encode("UTF-8", "Shift_JIS")
  utf[[i].pack('c*').encode("UTF-8", "Shift_JIS").bytes] = [i]
end

# Half-width Hiragana
(0xA1..0xDF).each do |i|
  jis["0x#{i.to_s(16).rjust(2, '0')}"] = [i].pack('c*').encode("UTF-8", "Shift_JIS")
  utf[[i].pack('c*').encode("UTF-8", "Shift_JIS").bytes] = [i]
end

# JIS X 0208
(0x81..0x9F).each do |i|
  (0x40..0x7E).each do |j|
    begin
      jis["0x#{i.to_s(16).rjust(2, '0')}#{j.to_s(16).rjust(2, '0')}"] = [i, j].pack('c*').encode("UTF-8", "SJIS")
      utf[[i, j].pack('c*').encode("UTF-8", "Shift_JIS").bytes] = [i, j]
    rescue Encoding::UndefinedConversionError
      # Ignore
    end
  end

  (0x80..0xFC).each do |j|
    begin
      jis["0x#{i.to_s(16).rjust(2, '0')}#{j.to_s(16).rjust(2, '0')}"] = [i, j].pack('c*').encode("UTF-8", "SJIS")
      utf[[i, j].pack('c*').encode("UTF-8", "Shift_JIS").bytes] = [i, j]
    rescue Encoding::UndefinedConversionError
      # Ignore
    end
  end
end


(0xE0..0xEF).each do |i|
  (0x40..0x7E).each do |j|
    begin
      jis["0x#{i.to_s(16).rjust(2, '0')}#{j.to_s(16).rjust(2, '0')}"] = [i, j].pack('c*').encode("UTF-8", "Shift_JIS")
      utf[[i, j].pack('c*').encode("UTF-8", "Shift_JIS").bytes] = [i, j]
    rescue Encoding::UndefinedConversionError
      # Ignore
    end
  end

  (0x80..0xFC).each do |j|
    begin
      jis["0x#{i.to_s(16).rjust(2, '0')}#{j.to_s(16).rjust(2, '0')}"] = [i, j].pack('c*').encode("UTF-8", "Shift_JIS")
      utf[[i, j].pack('c*').encode("UTF-8", "Shift_JIS").bytes] = [i, j]
    rescue Encoding::UndefinedConversionError
      # Ignore
    end
  end
end

puts "const JIS_TABLE = {"
jis.keys.each do |key|
  puts "  #{key}: #{jis[key].unpack('C*')},"
end
puts "};"

puts

puts "const UTF_TABLE = {"
utf.keys.each do |key|
  hex = key.map { |n| '%02x' % (n & 0xFF) }.join
  puts "  0x#{hex}: [#{utf[key].join(', ')}],"
end
puts "};"
