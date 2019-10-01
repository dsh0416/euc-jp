euc = {}
utf = {}

# ASCII Compatible
(0x00..0x7E).each do |i|
  euc["0x#{i.to_s(16).ljust(2, '0')}"] = [i].pack('c*').encode("UTF-8", "EUC-JP")
  utf[[i].pack('c*').encode("UTF-8", "EUC-JP").bytes] = [i]
end

# Hiragana
(0xA1..0xDF).each do |i|
  begin
    euc["0x8e#{i.to_s(16).ljust(2, '0')}"] = [0x8e, i].pack('c*').encode("UTF-8", "EUC-JP")
    utf[[0x8e, i].pack('c*').encode("UTF-8", "EUC-JP").bytes] = [0x8e, i]
  rescue Encoding::UndefinedConversionError
    # Ignore
  end
end

# JIS X 0208
(0xA1..0xFE).each do |i|
  (0xA1..0xFE).each do |j|
    begin
      euc["0x#{i.to_s(16).ljust(2, '0')}#{j.to_s(16).ljust(2, '0')}"] = [i, j].pack('c*').encode("UTF-8", "EUC-JP")
      utf[[i, j].pack('c*').encode("UTF-8", "EUC-JP").bytes] = [i, j]
    rescue Encoding::UndefinedConversionError
      # Ignore
    end
  end
end

# JIS X 0212
(0xA1..0xFE).each do |i|
  (0xA1..0xFE).each do |j|
    begin
      euc["0x8f#{i.to_s(16).ljust(2, '0')}#{j.to_s(16).ljust(2, '0')}"] = [0x8F, i, j].pack('c*').encode("UTF-8", "EUC-JP")
      utf[[0x8F, i, j].pack('c*').encode("UTF-8", "EUC-JP").bytes] = [0x8F, i, j]
    rescue Encoding::UndefinedConversionError
      # Ignore
    end
  end
end

puts "const EUC_TABLE = {"
euc.keys.each do |key|
  puts "  #{key}: #{euc[key].unpack('C*')},"
end
puts "};"

puts

puts "const UTF_TABLE = {"
utf.keys.each do |key|
  hex = key.map { |n| '%02x' % (n & 0xFF) }.join
  puts "  0x#{hex}: [#{utf[key].join(', ')}],"
end
puts "};"
