require 'idler'
require 'rubygems'
require 'highline/import'

def getPasswd(prompt = 'Password: ')
    ask(prompt) { |q| q.echo = false }
end

class CLINotifier
    def notify(msgs)
        body = ""
	msgs.values.each do |msg|
            body += "#{msg.to_s}\n\n"
        end
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
