require 'notifier'
require 'linux_icon'

class LinuxNotifier < Notifier
    def initialize
        super
        @icon = LMGtkIcon.new
        @maxNewMsgs = 5
    end

    def notify(msgs)
        body = ""
        tooltip = ""
        count = 0
        msgs.each do |msg|
            count += 1
            break if @maxNewMsgs != 0 and count > @maxNewMsgs
            msg_s = "#{msg.to_s}\n\n"
            tooltip += msg_s
            if not @seen.member? msg.uid
                body += msg_s
                @seen << msg.uid
            end
        end
        body.strip!
        tooltip.strip!
        @icon.notify tooltip
        return if body.length == 0
        body.gsub!(/&/,"&amp;")
        body.gsub!(/"/,"&quot;")
        body.gsub!(/</,"&lt;")
        body.gsub!(/>/,"&gt;")
        system("notify-send", 
               "-c", "email.arrived",
               "-i", "mail-unread", 
               "-t", "5000", 
               @@title, body)
    end
end

Gtk.init
