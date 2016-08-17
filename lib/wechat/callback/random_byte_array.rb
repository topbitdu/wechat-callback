class Wechat::Callback::RandomByteArray

  LENGTH = 16

  def self.create(length)

    raise ArgumentError.new('The length argument is required.') if length.blank?

    [*0..255].sample length

  end

end
