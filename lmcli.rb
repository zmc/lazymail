require 'idler'
require 'rubygems'
require 'highline/import'

def getPasswd(prompt = 'Password: ')
    ask(prompt) { |q| q.echo = false }
end

class CLINotifier
    def initialize
        @seen = []
    end

    def notify(msgs)
        body = ""
        msgs.values.each do |msg|
            if not @seen.member? msg.uid
                body += "#{msg.to_s}\n\n"
                @seen << msg.uid
            end
        end
        return if body.length == 0
        puts body
    end
end

def main
    $i = Idler.new(ask('Login: '), getPasswd)
    $i.notifier = CLINotifier.new
    $i.check
    sleep
end

if __FILE__ == $0
    main
end
