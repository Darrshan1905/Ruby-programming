require 'websocket-client-simple'

class ChatClient
    def initialize(url)
        @url = url
        @name = nil
        @ws = WebSocket::Client::Simple.connect(url)
    end

    def run
        @ws.on :open do
            puts "Connected to #{url}"
            print "Enter your name: "
        end
        
        @ws.on :message do |msg|
            puts msg.data
        end

        @ws.on :close do |event|
            puts "Connection closed"
        end

        @ws.on :error do |error|
            puts "Error: #{error.message}"
        end

        
        @name = $stdin.gets.chomp
        @ws.send("Name: #{@name}")
        puts "Enter an option\n1.Send broadcast msg\n2.Send private message\n3.Get Active List\n4.Exit"

        loop do
            input = $stdin.gets.chomp
            if input == '1'
                puts "Enter the broadcast message: "
                bmsg = $stdin.gets.chomp
                @ws.send(bmsg)
            elsif input == '2'
                puts "Enter whom to send the private message: "
                recvr = $stdin.gets.chomp
                puts "Enter the private message: "
                pmsg = $stdin.gets.chomp
                @ws.send("To: #{recvr}:#{pmsg}")
            elsif input == '3'
                @ws.send("online")
            else
                @ws.close
                break
            end
        end
    end
end

url = 'ws://localhost:5000' 
client = ChatClient.new(url)
client.run
