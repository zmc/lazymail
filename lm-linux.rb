require 'notifier'
require 'linux_notifier'
require 'mac_notifier'
require 'lmcli'

Mac = 'turtleneck'
Linux = 'tux'

if RUBY_PLATFORM =~ /darwin/
    $OS = Mac
else
    $OS = Linux
end

def main
    $i = Idler.new(ask('Login: '), getPasswd)
    case $OS
    when Mac
        $i.notifier = MacNotifier.new
    when Linux
        $i.notifier = LinuxNotifier.new
    end
    $i.check
    Gtk.main if $OS == Linux
end

if __FILE__ == $0
    main
end
