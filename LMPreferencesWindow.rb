class LMPreferencesWindow < NSWindow
	ib_outlet :username
	ib_outlet :password
	ib_outlet :application_controller
	ib_action :save
	
	attr_reader :username
	
	def save
		if @application_controller.setupAccount(String.new(@username.stringValue), 
			String.new(@password.stringValue))
			orderOut(nil)
		end
	end
end