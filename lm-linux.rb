require 'idler'
require 'notifier'
require 'linux_notifier'
require 'rubygems'
require 'highline/import'

def getPasswd(prompt = 'Password: ')
    ask(prompt) { |q| q.echo = false }
end

def main
    $i = Idler.new(ask('Login: '), getPasswd)
    $i.notifier = LinuxNotifier.new
    $i.check
    Gtk.main
end

if __FILE__ == $0
    main
end
