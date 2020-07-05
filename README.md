# PetShopDemo

A small veterinary clinic is in need of an application to allow their users to contact them easily and for them to provide information to their users about their pets. Implement this app with the following requirements:

	•	Fetch the config.json to check for chat and call feature availability and work hours
	•	
	•	Call and/or chat buttons are at the top (see wireframe)
	•	
	•	Office hours is displayed below the call and chat buttons
	•	
	•	If both the chat and call features are disabled, do not show the corresponding buttons
	•	
	•	Tapping on either buttons should display an alert with the following message
	⁃	if within work hours: “Thank you for getting in touch with us. We’ll get back to you as soon as possible”
	⁃	if outside work hours: “Work hours has ended. Please contact us again on the next work day”
	⁃	
	•	Fetch the pets.json for pet information to display on the screen
	•	
	•	Each pet information is presented in a cell with Image and title
	•	
	•	Tapping on a pet info cell would open a new screen that loads the pet information on a webview
	•	
	•	Views should adjust to orientation and screen size accordingly


DOs
	•	Handles HTTP status codes and network failure properly.
	•	Clean, readable and well-structured code.
	•	Follow good platform development guidelines where applicable.
	•	Host both json files in a temporary remote server of your choice


DONTs
	•	Do not use 3rd-party library

Bonus:
	•	Unit / UI tests
