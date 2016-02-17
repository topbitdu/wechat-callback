class Wechat::Callback::RandomByteArray

  LENGTH = 16

  def self.create(length)
    [*0..255].sample length
  end

end
