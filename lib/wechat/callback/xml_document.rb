class Wechat::Callback::XmlDocument

  extend Wechat::Core::Common

  ##
  # 消息加解密 技术方案
  # http://mp.weixin.qq.com/wiki/6/90f7259c0d0739bbb41d9f4c4c8e59a2.html
  def self.load(xml_text)

    assert_present! :xml_text, xml_text

    pairs = {}
    Nokogiri::XML(xml_text).xpath('/xml').first.children.each do |element| pairs[element.name] = element.text end
    pairs

  end

  # 消息加解密 技术方案
  # http://mp.weixin.qq.com/wiki/6/90f7259c0d0739bbb41d9f4c4c8e59a2.html
  def self.create(pairs)

    assert_present! :pairs, pairs

    xml = '<xml>'
    pairs.each do |name, value| xml << "<#{name}><![CDATA[#{value}]]></#{name}>" end
    xml << '</xml>'
    xml

  end

end
