include Facebook::Messenger

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  if !User.exists?(id_fb:message.sender["id"])
    # Create new user
    user = User.create(id_fb: message.sender["id"])
 #    message.reply(
 #    	text: 'New user created!'
	# )
    # user.name_first = 'Vishnu'
    # user.save
  else
  	user = User.where(id_fb: message.sender["id"]).first()
 #  	message.reply(
 #    	text: 'User already in database!'
	# )
  end

  # message.reply(
  # 	text: "Id=" + message.sender["id"]
  # 	)

  # FIRST CHECK IF WE ARE ROUTING. HANDLE IF NOT ROUTING

  if user.talking_to == nil || user.talking_to == 0
    rep = Command.execute(message.text, user).msg
    message.reply(msg)
  else
  	# Route!!
  	# message.sender_id
  	user2 = User.find(user.talking_to)
  	case message.text
  	when /\/exit/i
  		# Disconnect both
  		reply = {
  			attachment:{
	  			type: 'template',
	  			payload: {
	  				template_type: 'button',
	  				text: 'Your session has ended. How many karma points do you want to give your parter?',
	  				buttons: [
	  					{ type: 'postback', title: '1', payload: 'RATE_1_' + String(user2.id)},
	  					{ type: 'postback', title: '2', payload: 'RATE_2_' + String(user2.id)},
	  					{ type: 'postback', title: '3', payload: 'RATE_3_' + String(user2.id)}
	  				]
	  			}
  			}
  		}
  		message.reply(reply)
  		Bot.deliver({
		  recipient: {
		    id: user2.id_fb
		  },
		  message: reply,
		}, access_token: ENV['ACCESS_TOKEN'])
  	else
      # Check if there is an attachment
  	  if message.attachments == nil
	  	Bot.deliver({
		  recipient: {
		    id: user2.id_fb
		  },
		  message: {
		  	text: message.text
		  }
		}, access_token: ENV['ACCESS_TOKEN'])
	  else
	  	# Do nothing
	  	attachment = message.attachments[0]
	  	puts("Found attachment: " + attachment["type"])
	  	Bot.deliver({
		  recipient: {
		    id: user2.id_fb
		  },
		  message: {
		  	attachment: attachment
		  }
		}, access_token: ENV['ACCESS_TOKEN'])
	  end
  	end
  end
end

Bot.on :postback do |postback|
  case postback.payload
  when 'LANGUAGE_LEARN'
    text = 'What language would you like to learn? Type \'\\learn \', then the name of the language'
  when 'LANGUAGE_TEACH'
    text = 'What language would you like to teach? Type \'\\teach \', then the name of the language'
  else
  	text = 'Unhandled postback'
  end

  postback.reply(
    text: text
  )
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
