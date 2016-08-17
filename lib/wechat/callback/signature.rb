class Wechat::Callback::Signature

  # 验证服务器地址的有效性
  # http://mp.weixin.qq.com/wiki/17/2d4265491f12608cd170a95559800f2d.html#.E7.AC.AC.E4.BA.8C.E6.AD.A5.EF.BC.9A.E9.AA.8C.E8.AF.81.E6.9C.8D.E5.8A.A1.E5.99.A8.E5.9C.B0.E5.9D.80.E7.9A.84.E6.9C.89.E6.95.88.E6.80.A7
  #
  # token 可由开发者在开发者中心配置项任意填写
  # timestamp 时间戳
  # nonce 随机数
  #
  # 加密/校验流程如下：
  # 1. 将token、timestamp、nonce三个参数进行字典序排序
  # 2. 将三个参数字符串拼接成一个字符串进行sha1加密
  # 3. 开发者获得加密后的字符串可与signature对比，标识该请求来源于微信
  #
  def self.create(token, timestamp, nonce, *args)

    raise ArgumentError.new('The token argument is required.') if token.blank?

    Digest::SHA1.hexdigest [ token, nonce, timestamp, *args ].sort.join

  end

end
