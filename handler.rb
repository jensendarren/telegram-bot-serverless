require 'json'
require 'net/https'

TOKEN = ENV['TELEGRAM_TOKEN']

def hello(event:, context:)
  begin
    data = JSON.parse(event["body"])
    message = data["message"]["text"]
    chat_id = data["message"]["chat"]["id"]
    first_name = data["message"]["chat"]["first_name"]

    response = "Wecome #{first_name}! You said, #{message}"
    payload = {text: response, chat_id: chat_id}

    uri = URI("https://api.telegram.org")

    Net::HTTP.start(uri.hostname, uri.port, {use_ssl: true}) do |http|
      req = Net::HTTP::Post.new("/bot#{TOKEN}/sendMessage", {'Content-Type' => 'application/json'})
      req.body = payload.to_json
      http.request(req)
    end
  rescue Exception => e
    puts e.message
    puts e.backtrace.inspect
  end

  return { statusCode: 200 }
end

# Quick Ruby Test!
# Uncomment below to lines and test on local computer by running `ruby handler.rb` (note you may need to update some ids)
# event ={"body"=>"{\"update_id\":673032935,\n\"message\":{\"message_id\":25,\"from\":{\"id\":735947889,\"is_bot\":false,\"first_name\":\"Darren\",\"last_name\":\"Jensen\",\"language_code\":\"en\"},\"chat\":{\"id\":735947889,\"first_name\":\"Darren\",\"last_name\":\"Jensen\",\"type\":\"private\"},\"date\":1572085353,\"text\":\"mrs robinson\"}}", "isBase64Encoded"=>false}
# hello(event: event, context: nil)

# Quick CURL Test:
# Run the following on the terminal to try out the Telegram API via a Curl command (update the TOKEN of course!)
# curl --request POST --url https://api.telegram.org/bot<TOKEN>/sendMessage --header 'content-type: application/json' --data '{"text":"Wecome Darren! You said, why it not work","chat_id":735947889}'