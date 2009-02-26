require 'idler'
require 'rubygems'
require 'highline/import'

def getPasswd(prompt = 'Password: ')
    ask(prompt) { |q| q.echo = false }
end

class Idler
    def inform
        @msgInfo.values.each do |msg|
            puts "#{msg['FROM']}"
            puts "  #{msg['SUBJECT']}"
            puts "  #{msg['DATE']}"
            puts ""
        end
        return nil
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
