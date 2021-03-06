#
#  ApplicationController.rb
#  LazyMail
#
#  Created by Zack Cerza on 3/4/09.
#  Copyright (c) 2009 Zack Cerza. All rights reserved.
#

require 'osx/cocoa'
require 'mac_notifier'

include OSX

class ApplicationController < OSX::NSObject

    ib_outlet :menu
    ib_outlet :preferencesWindow
    ib_action :openInbox
    ib_action :checkMail

    def awakeFromNib
        @status_bar = NSStatusBar.systemStatusBar
        @status_item = @status_bar.statusItemWithLength(NSVariableStatusItemLength)
        @status_item.setHighlightMode(true)
        @status_item.setMenu(@menu)
        
        bundle = NSBundle.mainBundle
        @noMailIcon = NSImage.alloc.initWithContentsOfFile(bundle.pathForResource_ofType('nomail', 'tiff'))
        @newMailIcon = NSImage.alloc.initWithContentsOfFile(bundle.pathForResource_ofType('newmail', 'tiff'))

        @status_item.setImage(@noMailIcon)
        #@status_item.setAlternateImage(@newMailIcon)
        #@status_item.setToolTip("tooltip")
        @status_item.setTitle("0")

        @notifier = MacNotifier.new(self)
        @idler = nil
    end
    
    def validateMenuItem(menuItem)
        if ["Open Inbox", "Check Now"].member? menuItem.title
            return false unless @preferencesWindow.accountSaved
        end
        true
    end
    
    def setupAccount(user, password)
        @idler.disconnect if @idler != nil
        begin
            @idler = Idler.new(user, password)
        rescue Net::IMAP::NoResponseError
            alert = NSAlert.alloc.init
            alert.addButtonWithTitle("OK")
            alert.setMessageText("Unable to connect.")
            alert.setInformativeText("Your login or password may be incorrect.")
            alert.setAlertStyle(NSWarningAlertStyle)
            alert.runModal
            return false
        end
        @idler.notifier = @notifier
        checkMail
        return true
    end
    
    def checkMail
        @idler.check
    end
    
    def notify(msgs)
        case msgs.length
        when 0
            @status_item.setImage(@noMailIcon)
        else
            @status_item.setImage(@newMailIcon)
        end
        @status_item.setTitle(msgs.length.to_s)
    end
    
    def applicationWillTerminate(notification)
        @imap.disconnect if @imap != nil
    end
    
    def openInbox
        url = "http://mail.google.com/a/#{@preferencesWindow.username.stringValue.split('@')[1]}"
        NSWorkspace.sharedWorkspace.openURL(NSURL.URLWithString(url))
    end
end
