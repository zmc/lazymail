class Notifier
    @@title = 'New mail!'

    def initialize
        @seen = []
        @maxNewMsgs = 0
    end

    def notify(msgs)
        body = ""
        count = 0
        msgs.each do |msg|
            count += 1
            break if @maxNewMsgs != 0 and count > @maxNewMsgs
            if not @seen.member? msg.uid
                body += "#{msg.to_s}\n\n"
                @seen << msg.uid
            end
        end
        return if body.length == 0
        puts body
    end
end

