#
#  LMPreferencesWindow.rb
#  LazyMail
#
#  Created by Zack Cerza on 3/8/09.
#  Copyright (c) 2009 Zack Cerza. All rights reserved.
#

class LMPreferencesWindow < NSWindow
    ib_outlet :username
    ib_outlet :password
    ib_outlet :application_controller
    ib_action :save
    ib_action :reallyMakeKeyAndOrderFront
    
    attr_reader :username, :accountSaved
    
    def awakeFromNib
        @accountSaved = false
    end
    
    def reallyMakeKeyAndOrderFront
        NSApp.activateIgnoringOtherApps(true)
        orderFrontRegardless
        #makeKeyAndOrderFront
    end        
    
    def save
        if @application_controller.setupAccount(String.new(@username.stringValue), 
            String.new(@password.stringValue))
            @accountSaved = true
            orderOut(nil)
        end
    end
end