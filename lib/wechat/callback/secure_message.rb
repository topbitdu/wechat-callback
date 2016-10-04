class Wechat::Callback::SecureMessage

  extend Wechat::Core::Common

  RANDOM_LENGTH   = 16
  XML_SIZE_LENGTH = 4

  # 消息加解密
  # http://mp.weixin.qq.com/wiki/6/90f7259c0d0739bbb41d9f4c4c8e59a2.html
  #
  # random(16B) + msg_len(4B) + msg + $AppId + padding
  # padding: AES采用CBC模式，秘钥长度为32个字节，数据采用PKCS#7填充；PKCS#7：K为秘钥字节数（采用32），buf为待加密的内容，N为其字节数。Buf需要被填充为K的整数倍。在buf的尾部填充(K-N%K)个字节，每个字节的内容是(K- N%K)； 
  # 去掉rand_msg头部的16个随机字节，4个字节的msg_len,和尾部的$AppId即为最终的xml消息体
  def self.load(message_decryption)

    assert_present! :message_decryption, message_decryption
    #raise ArgumentError.new('The message_decryption argument is required.') if message_decryption.blank?

    random_bytes = message_decryption[0..(RANDOM_LENGTH-1)].bytes
    xml_size     = message_decryption[RANDOM_LENGTH..(RANDOM_LENGTH+XML_SIZE_LENGTH-1)].reverse.unpack('l').first

    text_decryption = message_decryption.bytes[(RANDOM_LENGTH+XML_SIZE_LENGTH)..(message_decryption.length-1)]
    xml_text        = byte_array_to_string text_decryption[0..(xml_size-1)]

    padding_length = message_decryption.last.unpack('C').first
    app_id         = byte_array_to_string text_decryption[xml_size..(text_decryption.length-1-padding_length)]
    padding_bytes  = text_decryption[(text_decryption.length-padding_length)..(text_decryption.length-1)]

    [ random_bytes, xml_size, xml_text, app_id, padding_bytes ]

  end

  # 消息加解密
  # http://mp.weixin.qq.com/wiki/6/90f7259c0d0739bbb41d9f4c4c8e59a2.html
  # 
  # random(16B) + msg_len(4B) + msg + $AppId + padding
  # padding: AES采用CBC模式，秘钥长度为32个字节，数据采用PKCS#7填充；PKCS#7：K为秘钥字节数（采用32），buf为待加密的内容，N为其字节数。Buf需要被填充为K的整数倍。在buf的尾部填充(K-N%K)个字节，每个字节的内容是(K- N%K)； 
  # 去掉rand_msg头部的16个随机字节，4个字节的msg_len,和尾部的$AppId即为最终的xml消息体
  def self.create(random_bytes, xml_text, app_id)

    raise ArgumentError.new('The random_bytes argument is required.') if random_bytes.blank?
    raise ArgumentError.new('The xml_text argument is required.'    ) if xml_text.blank?

    xml_size_bytes = [ xml_text.bytes.length ].pack('l').reverse.bytes
    buffer         = random_bytes+xml_size_bytes+xml_text.bytes+app_id.bytes
    padding_length = 32-buffer.length%32
    buffer         += [ padding_length ]*padding_length
    byte_array_to_string buffer
  end

  def self.byte_array_to_string(bytes)

    raise ArgumentError.new('The bytes argument is required.') if bytes.blank?

    bytes.inject('') do |buffer, byte| buffer += [ byte ].pack 'C' end
  end

end
