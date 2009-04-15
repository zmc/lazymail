require 'idler'
require 'notifier'
require 'linux_notifier'
require 'linux_connectionmonitor'
require 'rubygems'
require 'highline/import'

def getPasswd(prompt = 'Password: ')
    ask(prompt) { |q| q.echo = false }
end

def main
    $i = Idler.new(ask('Login: '), getPasswd)
    $i.notifier = LinuxNotifier.new
    $i.monitor = LinuxConnectionMonitor.new
    $i.check
    #Gtk.timeout_add(5*60*1000) { puts "time!"; $i.check; true; }
    Gtk.main
end

if __FILE__ == $0
    main
end
