require 'rubygems'
require 'lmcli'

begin
    require 'growl'
rescue LoadError
end

MAC = 'mac'
LINUX = 'linux'

class Notifier
    @@title = 'New mail!'
    attr_reader :growl

    def initialize
        case detectOS
        when MAC
            #require 'growl' # gem growlnotifier
            @growl = Growl::Notifier.sharedInstance
            @type = 'mail'
            @growl.register('Idler', [@type])
        end
    end

    def detectOS
        if RUBY_PLATFORM =~ /darwin/
            @os = MAC
        end
        return @os
    end

    def notify(body)
        case @os
        when MAC
            @growl.notify(@type, @@title, body)
        when LINUX
            system("notify-send", 
                   "-i", "mail-unread", 
                   "-t", "2500", 
                   "New mail!", "\"#{body}\"")
        end
    end
end

class Idler
    def inform
        body = ""
        @msgInfo.values.each do |msg|
            body = [body,
            "#{msg['FROM']}", 
            "#{msg['SUBJECT']}",
            "  #{msg['DATE']}",
            ""
            ].join("\n")
        end
        body.strip!
        if body.length > 0
            $n.notify(body)
        end
    end
end

def main
    $n = Notifier.new
    $i = Idler.new(ask('Login: '), getPasswd)
    $i.check
    sleep
end

if __FILE__ == $0
    main
end
