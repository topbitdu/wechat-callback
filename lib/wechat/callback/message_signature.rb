##
# Message Signature 是消息签名类。

class Wechat::Callback::MessageSignature

  extend Wechat::Core::Common

  # 消息加解密 技术方案
  # http://mp.weixin.qq.com/wiki/6/90f7259c0d0739bbb41d9f4c4c8e59a2.html
  #
  # 为了验证消息体的合法性，公众平台新增消息体签名，开发者可用以验证消息体的真实性，并对验证通过的消息体进行解密
  # msg_signature = sha1(sort(token、timestamp、nonce, encoded_message))
  #
  # encoded_message 前文描述密文消息体
  # token 公众平台上，开发者设置的 token
  # timestamp URL上原有参数，时间戳
  # nonce URL上原有参数，随机数
  #
  def self.create(encoded_message, token, timestamp, nonce)

    assert_present! :encoded_message, encoded_message
    assert_present! :token,           token
    assert_present! :timestamp,       timestamp
    assert_present! :nonce,           nonce
    #raise ArgumentError.new('The encoded_message argument is required.') if encoded_message.blank?
    #raise ArgumentError.new('The token argument is required.'          ) if token.blank?

    Digest::SHA1.hexdigest [ token, timestamp, nonce, encoded_message ].sort.join

  end

end
