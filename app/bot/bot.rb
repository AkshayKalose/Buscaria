include Facebook::Messenger

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  # case message.sender
    # check if in database
  # end

  case message.text
  when /help/i
    message.reply(
	  attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: 'Welcome to Buscaria! We connect people who want to learn a new language to real people who want to help them. Would you like to learn or teach?',
          buttons: [
            { type: 'postback', title: 'Learn!', payload: 'LANGUAGE_LEARN' },
            { type: 'postback', title: 'Teach!', payload: 'LANGUAGE_TEACH' }
          ]
        }
      }
    )
  when /\/practice ([a-zA-Z]*) (\d*)/i

  	var1 = $LAST_MATCH_INFO[1]

     # Check if anyone can help in database

     # if

    message.reply(
      text: 'Great! Let\'s get started with ' + $1 + ' at level ' + $2
    )

     # else

    message.reply(
      text: 'Sorry, there is no one available to teach you ' + $1 + 'at level ' + $2
	)

    # message.reply(
    #   attachment: {
    #     type: 'image',
    #     payload: {
    #       url: 'https://i.imgur.com/iMKrDQc.gif'
    #     }
    #   }
    # )

    # message.reply(
    #   attachment: {
    #     type: 'template',
    #     payload: {
    #       template_type: 'button',
    #       text: 'Did human like it?',
    #       buttons: [
    #         { type: 'postback', title: 'Yes', payload: 'HUMAN_LIKED' },
    #         { type: 'postback', title: 'No', payload: 'HUMAN_DISLIKED' }
    #       ]
    #     }
    #   }
    # )
  else
    message.reply(
      text: 'You are now marked for extermination.'
    )

    message.reply(
      text: 'Have a nice day.'
    )
  end
end

Bot.on :postback do |postback|
  case postback.payload
  when 'LANGUAGE_LEARN'
    text = 'What language would you like to learn? Type \'\\learn \', then the name of the language'
  when 'LANGUAGE_TEACH'
    text = 'What language would you like to teach? Type \'\\teach \', then the name of the language'
  end

  postback.reply(
    text: text
  )
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
