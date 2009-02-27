require 'rubygems'
require 'lmcli'

begin
    require 'growl'
rescue LoadError
end

Mac = 'turtleneck'
Linux = 'tux'

class Notifier
    @@title = 'New mail!'

    def initialize
        @seen = []
        case detectOS
        when Mac
            @growl = Growl::Notifier.sharedInstance
            @type = 'mail'
            @growl.register('Idler', [@type])
        end
    end

    def detectOS
        if RUBY_PLATFORM =~ /darwin/
            @os = Mac
        else
            @os = Linux
        end
        return @os
    end

    def notify(msgs)
        body = ""
        msgs.values.each do |msg|
            if not @seen.member? msg.uid
                body += "#{msg.to_s}\n\n"
                @seen << msg.uid
            end
        end
        body.strip!
        return if body.length == 0
        case @os
        when Mac
            @growl.notify(@type, @@title, body)
        when Linux
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
