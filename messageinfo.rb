
class MessageInfo
    attr_reader :date, :from, :subject, :uid
    def initialize(date, from, subject, uid)
        @date = date
        @from = from
        @subject = subject
        @uid = uid
    end

    def to_s
        [@from, "  #{@subject}", "  #{@date}"].join("\n").strip
    end
end
