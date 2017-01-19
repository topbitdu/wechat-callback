class Wechat::Callback::RandomByteArray

  extend Wechat::Core::Common

  LENGTH = 16

  ##
  # 常见一个指定长度的随机字节数组。
  def self.create(length = LENGTH)

    assert_present! :length, length

    [*0..255].sample length

  end

end
