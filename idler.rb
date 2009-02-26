require 'net_imap_idle'
require 'time'
#require 'pp'
#$DEBUG = true

class Idler
    attr_reader :imap, :idle, :unseen, :msgInfo
    @@host = 'imap.gmail.com'
    @@port = 993

    def initialize(user, password)
        @inbox = 'INBOX'
        @user = user
        @_password = password
        login
        @unseen = 0
        @msgInfo = {}
        addHandler
    end

    def login
        @imap = Net::IMAP.new(@@host, @@port, true)
        @imap.login(@user, @_password)
        @imap.examine(@inbox)
        @imap.subscribe(@inbox)
    end

    def startIdle
        @imap.idle
        @idle = true
    end

    def stopIdle
        @imap.done
        @idle = false
    end

    def addHandler
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
        puts "*** #{unseen} unread ***" if $DBUG
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
                @msgInfo[uid] = {"FROM" => from, "DATE" => date, 
                    "SUBJECT" => subj }
            end
        end
        startIdle
        @unseen = unseen
        inform
    end

    def inform
    end

end

if __FILE__ == $0
    puts "hi"
end
