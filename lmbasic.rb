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
        body.strip!
        case @os
        when MAC
            @growl.notify(@type, @@title, body)
        when LINUX
            body.gsub!(/&/,"&amp;")
            body.gsub!(/"/,"&quot;")
            body.gsub!(/</,"&lt;")
            body.gsub!(/>/,"&gt;")
            system("notify-send", 
                   "-c", "email.arrived",
                   "-i", "mail-unread", 
                   "-t", "5000", 
                   "New mail!", body)
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
