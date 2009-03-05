require 'idler'
require 'notifier'
require 'rubygems'
require 'highline/import'

def getPasswd(prompt = 'Password: ')
    ask(prompt) { |q| q.echo = false }
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
