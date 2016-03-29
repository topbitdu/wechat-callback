# Wechat Callback 微信回调库

[![License](https://img.shields.io/badge/license-MIT-green.svg)](http://opensource.org/licenses/MIT)
[![Gem Version](https://badge.fury.io/rb/wechat-callback.svg)](https://badge.fury.io/rb/wechat-callback)

Wechat Callback Library is a code base to handle the callbacks from the Wechat servers.
微信回调库用于处理微信主动向服务器传回事件通知、即时消息等。

## Recent Update
Check out the [Road Map](ROADMAP.md) to find out what's the next.
Check out the [Change Log](CHANGELOG.md) to find out what's new.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wechat-callback'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wechat-callback

## Usage

Gengerate Signature 生成参数签名
```ruby
signature = Wechat::Callback::Signature.create token, timestamp, nonce, text_1, text_2, text_3
```

Generate Message Signature 生成消息题签名
```ruby
message_signature = Wechat::Callback::MessageSignature.create encoded_message, token, timestamp, nonce
```

Parse XML Text into Hash 将XML文本解析成Hash
```ruby
xml_document = Wechat::Callback::XmlDocument.load '<xml><FromUserID>FUID</FromUserID></xml>'
```

Convert Hash into XML Text 将Hash转换成XML文本
```ruby
xml_text = Wechat::Callback::XmlDocument.create FromUserID: 'FUID', ToUserID: 'TUID' # <xml><FromUserID>FUID</FromUserID><ToUserID>TUID</ToUserID></xml>
```

Real Example for handling Wechat Message for Rails
微信上的“消息加解密方式”必须是“安全模式”，不能是“明文模式”或者“兼容模式”
```ruby
if Wechat::Callback::Signature.create(wechat_token, timestamp, nonce)==params[:signature]
  encoded_message = Wechat::Callback::XmlDocument.load(request.body.read)['Encrypt']
  if Wechat::Callback::MessageSignature.create(encoded_message, Rails.application.secrets.wechat_validation_token, params[:timestamp], params[:nonce])==message_signature
    message = Wechat::Callback::MessageDecryption.create encoded_message, Rails.application.secrets.wechat_encoding_aes_keys
    random_bytes, xml_size, xml_text, app_id, padding_bytes = Wechat::Callback::SecureMessage.load message
    if Rails.application.secrets.wechat_app_id==app_id
      pairs = Wechat::Callback::XmlDocument.load xml_text
      replying_pairs = {
          'ToUserName'   => pairs['FromUserName'],
          'FromUserName' => pairs['ToUserName'],
          'CreateTime'   => Time.now.to_i,
          'MsgType'      => 'text',
          'Content'      => '您好！'
        }
      replying_xml_text = Wechat::Callback::XmlDocument.create replying_pairs

      random_bytes       = Wechat::Callback::RandomByteArray.create 16
      plain_text         = Wechat::Callback::SecureMessage.create random_bytes, replying_xml_text, Rails.application.secrets.wechat_app_id
      encrypted          = Wechat::Callback::MessageEncryption.create plain_text, Rails.application.secrets.wechat_encoding_aes_keys
      replying_singature = Wechat::Callback::Signature.create Rails.application.secrets.wechat_validation_token, params[:timestamp], params[:nonce], encrypted
      encrypted_replying_pairs = {
          'Encrypt'      => encrypted,
          'MsgSignature' => replying_singature,
          'TimeStamp'    => params[:timestamp],
          'Nonce'        => params[:nonce]
        }
      replying_xml_text = Wechat::Callback::XmlDocument.create encrypted_replying_pairs
      render status: 200, xml: replying_xml_text
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/topbitdu/wechat-callback. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

