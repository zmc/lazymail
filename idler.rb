require 'net_imap_idle'
require 'time'
require 'messageinfo'
require 'connectionmonitor'

class Idler
    attr_reader :imap, :idle, :unseen, :msgInfo, :notifier, :monitor
    attr_writer :notifier, :monitor
    @@host = 'imap.gmail.com'
    @@port = 993

    def initialize(user, password)
        @inbox = 'INBOX'
        @user = user
        @_password = password
        login
        @unseen = 0
        @msgInfo = {}
        @notifier = nil
        @monitor = ConnectionMonitor.new
        addMailHandler
    end

    def login
        @imap = Net::IMAP.new(@@host, @@port, true)
        @imap.login(@user, @_password)
        @imap.examine(@inbox)
        @imap.subscribe(@inbox)
    end
    
    def disconnect
        @imap.disconnect
    end

    def startIdle
        @imap.idle
        @idle = true
    end

    def stopIdle
        @imap.done
        @idle = false
    end

    def monitor=(monitor)
        @monitor = monitor
        addConnectionHandler if not @monitor.monitoring?
    end

    def addConnectionHandler
        @monitor.onChange do |online|
            if online
                login
                check
            end
        end
    end

    def addMailHandler
        @imap.add_response_handler { |resp|
            puts "#{resp.class} => #{resp.data}" if $DEBUG
            if (resp.kind_of?(Net::IMAP::UntaggedResponse) and 
                resp.name == "EXISTS")
                Thread.start { check }
            end
        }
    end
    
    def check
        stopIdle if @idle
        msgIDs = @imap.uid_search("UNSEEN")
        puts "*** #{unseen} unread ***" if $DEBUG
        unseen = msgIDs.length
        @msgInfo.delete_if { |k, v| not msgIDs.member? k }
        msgIDs.delete_if { |id| @msgInfo.keys.member? id  }
        if msgIDs != []
            msgDump = imap.uid_fetch(msgIDs, "ENVELOPE")
            msgDump.each do |dump|
                uid = dump[1]["UID"]
                envelope = dump[1]["ENVELOPE"]
                date = Time.parse(envelope.date).ctime
                subj = envelope.subject
                f = envelope.from[0]
                if f.name
                    from = "#{f.name} <#{f.mailbox}@#{f.host}>"
                else
                    from = "#{f.mailbox}@#{f.host}"
                end
                @msgInfo[uid] = MessageInfo.new(date, from, subj, uid)
            end
        end
        startIdle
        @unseen = unseen
        inform
    end

    def inform
        if (@msgInfo.keys.length > 0) and @notifier
            @notifier.notify(@msgInfo.values.sort{|a,b| a.uid <=> b.uid}.reverse)
        end
    end

end

if __FILE__ == $0
    puts "hi"
end
