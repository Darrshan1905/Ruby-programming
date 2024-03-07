require 'websocket-client-simple'

class ChatClient
    def initialize(url)
        @url = url
        @name = nil
        @ws = WebSocket::Client::Simple.connect(url)
    end

    def run
        #connection established
        @ws.on :open do
            puts "Connected to #{url}"
            print "Enter your name: "
        end
        
        #received message
        @ws.on :message do |msg|
            puts "\n",msg.data
        end

        #connection closed
        @ws.on :close do |event|
            puts "Connection closed"
        end

        #error occured
        @ws.on :error do |error|
            puts "Error: #{error.message}"
        end

        #get user name and send to server
        @name = $stdin.gets.chomp
        @ws.send("Name: #{@name}")

        puts "Enter an option\n1.Send broadcast msg\n2.Send private message\n3.Get Active List\n4.Update Name\n5.Exit"

        #keep the program running until exit
        loop do
            input = $stdin.gets.chomp

            #broadcast message
            if input == '1'
                puts "Enter the broadcast message: "
                bmsg = $stdin.gets.chomp
                @ws.send(bmsg)

            #private message
            elsif input == '2'
                puts "Enter whom to send the private message: "
                recvr = $stdin.gets.chomp
                puts "Enter the private message: "
                pmsg = $stdin.gets.chomp
                @ws.send("To: #{recvr}:#{pmsg}")
            
            #get active list
            elsif input == '3'
                @ws.send("online")

            #update name
            elsif input == '4'
                print "Enter your name: "
                @name = $stdin.gets.chomp
                @ws.send("Name: #{@name}")
                puts "Updated name to #{@name}"

            #close websocket connection
            elsif input == '5'
                @ws.close
                break
            
            #for invalid options
            else
                puts "Wrong option... Please enter a valid option"
            end
        end
    end
end

url = 'ws://localhost:5000' 
client = ChatClient.new(url)
client.run


#test-case

#test-case -1 
#connection establishment with the server - worked correctly

#test-case -2
#name set - worked correctly

#test-case -3
#private messages with other client - worked correctly

#test-case -4
#broadcast messages with other client - worked correctly

#test-case -5
#active client list - worked correctly

#test-case -5 
#update name for the client - added and worked correctly

#test-case -6
#invalid option is added 



