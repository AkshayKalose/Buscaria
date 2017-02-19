include Facebook::Messenger

def find_user(fb_id)
  if !User.exists?(id_fb: fb_id)
    # Create new user
    user = User.create(id_fb: fb_id)
    #    message.reply(
    #    	text: 'New user created!'
    # )
    # user.name_first = 'Vishnu'
    # user.save
  else
    user = User.where(id_fb: fb_id).first()
    #  	message.reply(
    #    	text: 'User already in database!'
    # )
  end
  return user
end

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  user = find_user(message.sender["id"])

  # message.reply(
  # 	text: "Id=" + message.sender["id"]
  # 	)

  # FIRST CHECK IF WE ARE ROUTING. HANDLE IF NOT ROUTING

  msg_text = message.text == nil ? "" : message.text

  if user.talking_to == nil || user.talking_to == 0
    rep = Command.execute(msg_text, user, :main)
    message.reply(rep.msg)
  else
    rep = Command.execute(msg_text, user, :route)
    if rep.success
      message.reply(rep.msg)
    else
      # Route!!
      # message.sender_id
      user2 = User.find(user.talking_to)
      # Check if there is an attachment
      if message.attachments == nil
        Bot.deliver({
                      recipient: {
                        id: user2.id_fb
                      },
                      message: {
		  	text: msg_text
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
  text = ""
  case postback.payload
  when /^RATE_(\d)_(.+)/i
    user = User.find($2.to_i)
    user.points += $1.to_i
    user.save
    Bot.deliver({
                  recipient: {
                    id: user.id_fb
                  },
                  message: {
                    text: "Congratulations, you recieved #{$1} karma points! You now have #{user.points} karma points."
                  }
                }, access_token: ENV['ACCESS_TOKEN'])
  else
    text = 'Unhandled postback'
  end

  if text != ""
    postback.reply(text: text)
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
