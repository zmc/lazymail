#
#  ApplicationController.rb
#  LazyMail
#
#  Created by Zack Cerza on 3/4/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'
require 'mac_notifier'

include OSX

class ApplicationController < OSX::NSObject

    ib_outlet :menu
	ib_outlet :preferencesWindow

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
	
	def setupAccount(user, password)
		@idler.disconnect if @idler != nil
		@idler = Idler.new(user, password)
		@idler.notifier = @notifier
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
end
