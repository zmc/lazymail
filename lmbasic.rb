require 'lmcli'

class Idler
    def inform
        body = ""
        @msgInfo.values.each do |msg|
            body = [body,
            "#{msg['FROM']}", 
            "#{msg['SUBJECT']}",
            "  #{msg['DATE']}"
            ].join("")
        end
        if body.length > 0
            system("notify-send", 
                   "-i", "mail-unread", 
                   "-t", "2500", 
                   "New mail!", "\"#{body}\"")
            puts body
        end
    end
end

def main
    $i = Idler.new(ask('Login: '), getPasswd)
    $i.check
    sleep
end

if __FILE__ == $0
    main
end
