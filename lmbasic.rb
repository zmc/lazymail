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

    def initialize
        case detectOS
        when MAC
            @growl = Growl::Notifier.sharedInstance
            @type = 'mail'
            @growl.register('Idler', [@type])
        end
    end

    def detectOS
        if RUBY_PLATFORM =~ /darwin/
            @os = MAC
        else
            @os = LINUX
        end
        return @os
    end

    def notify(msgs)
        body = ""
	msgs.values.each do |msg|
            body += "#{msg.to_s}\n\n"
        end
        case @os
        when MAC
            @growl.notify(@type, @@title, body)
        when LINUX
            system("notify-send", 
                   "-i", "mail-unread", 
                   "-t", "2500", 
                   "New mail!", body.gsub(/\n/, ""))
        end
    end
end

def main
    $i = Idler.new(ask('Login: '), getPasswd)
    $i.notifier = Notifier.new
    $i.check
    sleep
end

if __FILE__ == $0
    main
end
