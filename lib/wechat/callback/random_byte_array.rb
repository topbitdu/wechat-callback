class Wechat::Callback::RandomByteArray

  extend Wechat::Core::Common

  LENGTH = 16

  def self.create(length)

    assert_present! :length, length
    #raise ArgumentError.new('The length argument is required.') if length.blank?

    [*0..255].sample length

  end

end
