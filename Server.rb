ENV['SSL_CERT_FILE'] = File.expand_path('C:\Users\backn\ca-bundle.crt')

require 'socket'
require 'json'
require 'dotenv'
require 'slack/incoming/webhooks'
require File.dirname(__FILE__) + '/BodiesData'

class Server

  Dotenv.load
  slack = Slack::Incoming::Webhooks.new ENV['SLACK_URL']
  ip = Socket.getifaddrs.select{|x| x.name == "wireless_32768" and x.addr.ipv4?}.first.addr.ip_address
  server = TCPServer.open(ip, 8000)

  while true
    p("待受状態開始")

    Thread.start(server.accept) do |client|
      p(client, "接続完了")

      begin
        while buffer = client.gets

          #デシリアライズ
          json = JSON.parse(buffer)

          #Bodyデータ格納用オブジェクト精製
          bodies_data = BodiesData.new(json["channel"], json["Time"], json["RecognizedBodyCount"], json["bodies"])

          #出力
          bodies_data.dump()
          p("-------------------------------------")
        end

      rescue => ex

        #通知など
        p(ex.message)
        slack.post(ex.message)

        #後処理
        p(client, "接続解除")
        client.close

      end
    end
  end

end

## Slack通知＆操作、Jenkinsで自動デプロイ、常に起動、
### こちらの内部処理で異常停止時のエラー送信。外部処理でスタート用と終了用と状態確認のexecプログラム
### あちらの内部処理で異常停止時のエラー送信。外部処理でスタート用と終了用と状態確認のexecプログラム

## デプロイの自動化。サーバ機のjenkinsでデプロイ検知したら各クライアントにSSH繋いでClone＆Compile
