require 'dbus'
require 'connectionmonitor'

#nmIface = nmObj["org.freedesktop.NetworkManager"]

NM_STATE_UNKNOWN      = 0
NM_STATE_ASLEEP       = 1
NM_STATE_CONNECTING   = 2
NM_STATE_CONNECTED    = 3
NM_STATE_DISCONNECTED = 4
class LinuxConnectionMonitor < ConnectionMonitor
    def initialize
        @thread = nil
        @monitoring = false
        connectToBus
    end

    def connectToBus
        @bus = DBus::SystemBus.instance
        @nmService = @bus.service("org.freedesktop.NetworkManager")
        @nmObj = @nmService.object("/org/freedesktop/NetworkManager")
        @nmObj.introspect
        @nmObj.default_iface = "org.freedesktop.NetworkManager"
    end

    def onChange
        @nmObj.on_signal("StateChange") { |state|
            case state
            when NM_STATE_CONNECTED
                yield true
            when NM_STATE_DISCONNECTED
                yield false
            end
        }
        start
    end

    def start
        @thread = Thread.start {
            loop = DBus::Main.new
            loop << @bus
            loop.run
        }
        @monitoring = true
    end

    def stop
        @thread.exit if @thread != nil
        @monitoring = false
    end

    def connected?
        return false unless @nmObj.state[0] == NM_STATE_CONNECTED
        true
    end
end
