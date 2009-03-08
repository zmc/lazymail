class LMPreferencesWindow < NSWindow
	ib_outlet :username
	ib_outlet :password
	ib_outlet :application_controller
	ib_action :save
	
	def save
		orderOut(nil)
		@application_controller.setupAccount(String.new(@username.stringValue), 
			String.new(@password.stringValue))
	end
end