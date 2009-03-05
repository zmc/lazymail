class Notifier
    @@title = 'New mail!'

    def initialize
        @seen = []
    end

    def notify(msgs)
        body = ""
        msgs.each do |msg|
            if not @seen.member? msg.uid
                body += "#{msg.to_s}\n\n"
                @seen << msg.uid
            end
        end
        return if body.length == 0
        puts body
    end
end

