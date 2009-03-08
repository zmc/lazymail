require 'notifier'
require 'rubygems'
require 'growl' # gem install growlnotifier

class MacNotifier < Notifier
    def initialize(appController)
        super()
		@appController = appController
		@growl = Growl::Notifier.sharedInstance
        @type = 'mail'
        @growl.register('Idler', [@type])
    end

    def notify(msgs)
        body = ""
        msgs.each do |msg|
            if not @seen.member? msg.uid
                body += "#{msg.to_s}\n\n"
                @seen << msg.uid
            end
        end
        body.strip!
        return if body.length == 0
		@appController.notify(msgs)
        @growl.notify(@type, @@title, body)
    end
end
