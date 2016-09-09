require 'socket'
require 'json'

require File.dirname(__FILE__) + '/BodiesData'

class Listener

  server = TCPServer.open(8000)

  while true
    p("待受状態開始")

    Thread.start(server.accept) do |client|       # save to dynamic variable
      p(client, "接続完了")

      begin
        while buffer = client.gets

          #デシリアライズ
          json = JSON.parse(buffer)

          #Bodyデータ格納用オブジェクト精製
          bodies_data = BodiesData.new(json["channel"], json["Time"], json["RecognizedBodyCount"], json["Bodies"])

          #出力
          bodies_data.dump()
          p("-------------------------------------")
        end

      rescue => ex

        #エラー時処理
        p(ex.message)
        # TODO 通知
        p(client, "接続解除")
        client.close

      end
    end
  end

end

## Slack通知＆操作、Jenkinsで自動デプロイ、常に起動、
