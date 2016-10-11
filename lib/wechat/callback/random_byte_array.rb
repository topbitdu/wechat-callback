class Wechat::Callback::RandomByteArray

  extend Wechat::Core::Common

  LENGTH = 16

  def self.create(length)

    assert_present! :length, length

    [*0..255].sample length

  end

end
