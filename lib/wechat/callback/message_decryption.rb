##
# Message Decryption 是消息解密类。

class Wechat::Callback::MessageDecryption

  extend Wechat::Core::Common

  ##
  # 消息加解密
  # http://mp.weixin.qq.com/wiki/6/90f7259c0d0739bbb41d9f4c4c8e59a2.html
  #
  # 解密方式如下：
  # 1. aes_msg = Base64_Decode(msg_encrypt)
  # 2. rand_msg = AES_Decrypt(aes_msg)
  #
  def self.create(encoded_message, encoded_aes_keys)

    assert_present! :encoded_message,  encoded_message
    assert_present! :encoded_aes_keys, encoded_aes_keys

    encrypted_message = Base64.decode64(encoded_message).bytes.inject('') do |buffer, byte| buffer += [ byte ].pack 'C' end
    aes_keys          = encoded_aes_keys.map { |encoded_aes_key| Base64.decode64 "#{encoded_aes_key}=" }

    cipher = OpenSSL::Cipher::AES.new(256, 'CBC')
    cipher.decrypt
    cipher.padding = 0
    cipher.key     = aes_keys.first

    cipher.update(encrypted_message)+cipher.final

  end

end
