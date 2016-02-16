class Wechat::Callback::MessageEncryption

  # 消息加解密
  # http://mp.weixin.qq.com/wiki/6/90f7259c0d0739bbb41d9f4c4c8e59a2.html
  #
  # AES密钥：AESKey=Base64_Decode(EncodingAESKey + “=”)，EncodingAESKey尾部填充一个字符的“=”, 用Base64_Decode生成32个字节的AESKey
  # msg_encrypt=Base64_Encode(AES_Encrypt [random(16B)+ msg_len(4B) + msg + $AppId])
  def self.create(plain_text, encoded_aes_keys)

    cipher = OpenSSL::Cipher::AES.new(256, 'CBC')
    cipher.encrypt
    cipher.padding = 0
    cipher.key     = Base64.decode64 "#{encoded_aes_keys.first}="

    Base64.encode64 cipher.update(plain_text)+cipher.final

  end

end
