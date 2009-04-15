class ConnectionMonitor
    def initialize
        @monitoring = false
    end

    def start
        true
    end

    def monitoring?
        @monitoring
    end

    def onChange
        true
    end

    def stop
        true
    end

    def connected?
        true
    end
end
