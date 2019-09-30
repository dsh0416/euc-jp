result = {}

# ASCII Compatible
(0x00..0x7E).each do |i|
  result["0x#{i.to_s(16).ljust(2, '0')}"] = [i].pack('c*').encode("UTF-8", "EUC-JP")
end

# Hiragana
(0xA1..0xDF).each do |i|
  begin
    result["0x8e#{i.to_s(16).ljust(2, '0')}"] = [0x8e, i].pack('c*').encode("UTF-8", "EUC-JP")
  rescue Encoding::UndefinedConversionError
    # Ignore
  end
end

# JIS X 0208
(0xA1..0xFE).each do |i|
  (0xA1..0xFE).each do |j|
    begin
      result["0x#{i.to_s(16).ljust(2, '0')}#{j.to_s(16).ljust(2, '0')}"] = [i, j].pack('c*').encode("UTF-8", "EUC-JP")
    rescue Encoding::UndefinedConversionError
      # Ignore
    end
  end
end

# JIS X 0212
(0xA1..0xFE).each do |i|
  (0xA1..0xFE).each do |j|
    begin
      result["0x8f#{i.to_s(16).ljust(2, '0')}#{j.to_s(16).ljust(2, '0')}"] = [0x8F, i, j].pack('c*').encode("UTF-8", "EUC-JP")
    rescue Encoding::UndefinedConversionError
      # Ignore
    end
  end
end

puts "const EUC_TABLE = {"
result.keys.each do |key|
  puts "  #{key}: #{result[key].unpack('C*')},"
end
puts "};"
