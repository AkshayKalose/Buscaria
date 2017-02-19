
class Reply
  def initialize(success, msg)
    @success = success
    @msg = msg
  end
  def success
    @success
  end
  def msg
    @msg
  end
end

class Command

  def self.descendants
    @descendants ||= []
  end

  def self.inherited(descendant)
    descendants << descendant
  end
  
  def self.execute(msg, user, mode)
    clean_msg = msg.strip.downcase
    self.descendants.each do |d|
      if d.modes.include? mode
        s = (mode == :route) ? "/" + d.string : d.string
        if s == clean_msg
          return d.execute("", user)
        else
          str_rgx = "^" + s + " +(.*)"
          reg = Regexp.new(str_rgx)
          if m = reg.match(clean_msg)
            return d.execute(m[1], user)
          end
        end
      end
    end
    return Reply.new(false, text: "Sorry, I didn't understand. Send \"help\" to list commands")
  end
  
end

class Help < Command

  def self.modes
    [:main]
  end

  def self.string
    "help"
  end

  def self.execute(args, user)
    Reply.new(true, text: "Welcome to Buscaria! We connect people who want to learn a new language to real people who want to help them. If you would like to learn, text \"learn <language> <proficiency>\", where proficiency is a value from 1 to 5, 1 meaning you know nothing and 5 meaning you're a native speaker. Busscaria will automatically connect you with someone who is willing to teach. If you would like to teach, text \"teach <language> <proficiency>\", and Buscaria will contact you when someone asks to learn. Type \"help\" to see this message again. Have fun!")
  end
end

class Learn < Command

  def self.modes
    [:main]
  end

  def self.string
    "learn"
  end

  def self.execute(args, user)
    if m = /([a-zA-Z]*) +(\d*)/.match(args)
      level = m[2].to_i
      if level < 1 or level > 5
        return Reply.new(false, text: "Your proficiency must be an integer number from 1 to 5, where 1 means you know nothing and 5 means you are a native speaker.")
      else

        lang = Language.where(name:m[1]).first
        if lang == nil
          return Reply.new(false, text: "Alas, Buscaria cannot find the language you requested. Perhaps no one has signed up to teach it, or maybe you spelled it wrong. Try different forms of the language (e.g. \"Espanol\" instead of \"Spanish\"")
        end

        users = User.joins(:teachables).where(teachables: {language: lang, level: [level..5]}).where.not(users: { id: user.id })

        if users.size == 0
          return Reply.new(false, text: "Alas, Buscaria cannot find anyone who speaks the language at the higher proficiency than you. Try again later.")
        end

        user2 = users.where(talking_to: nil).first

        if user2 == nil
          return Reply.new(false, text: "Buscaria has found people who are willing to teach you this language, but all are conversing with other people at the moment. Try again later.")
        end

        user.talking_to = user2.id
        user2.talking_to = user.id

        msg_text = "Hello, you are now connected with someone who is ready to learn #{m[1].capitalize}. Their proficiency in this language is #{m[2]}. Your messages will now be routed to them. Text /exit at any time to exit."
        
        Bot.deliver({
                      recipient: {
                        id: user2.id_fb
                      },
                      message: {
                        text: msg_text
                      }
                    }, access_token: ENV['ACCESS_TOKEN'])
        puts msg_text

        user.save
        user2.save
        
        return Reply.new(true, text: "You are now connected with someone who is ready to teach #{m[1].capitalize}. Your messages will now be routed to the. Text /exit at any time to exit.")
      end
    else
      return Reply.new(false, text: "I cannot understand. The syntax for the \"learn\" command is \"learn <language> <your proficiency from 1 to 5>\". E.g. \"learn Spanish 2\"");
    end
  end


  class Teach < Command

    def self.modes
      [:main]
    end

    def self.string
      "teach"
    end

    def self.execute(args, user)
      if m = /([a-zA-Z]*) +(\d*)/.match(args)
        level = m[2].to_i
        if level < 1 or level > 5
          return Reply.new(false, text: "Your proficiency must be an integer number from 1 to 5, where 1 means you know nothing and 5 means you are a native speaker.")
        else

          lang = Language.where(name:m[1]).first
          if lang == nil
            lang = Language.create(name:m[1])
          end

          teach = Teachable.where(user: user).first
          if (teach == nil)
            teach = Teachable.create(user: user,
                                     language: lang,
                                     level: level)
          else
            teach.level = level
            teach.save
          end
          
          
          return Reply.new(true, text: "You have been added to the database. You will be contacted when someone asks to learn #{m[1].capitalize}.")
        end
      else
        return Reply.new(false, text: "I cannot understand. The syntax for the \"teach\" command is \"learn <language> <your proficiency from 1 to 5>\". E.g. \"learn Spanish 2\"");
      end
    end

  end
  
end

class Exit < Command
  
  def self.modes
    [:route]
  end

  def self.string
    "exit"
  end

  def self.gen_rating(user)
    reply = {
      attachment:{
        type: 'template',
        payload: {
          template_type: 'button',
          text: 'Your session has ended. How many karma points do you want to give your parter?',
          buttons: [
                    { type: 'postback', title: '1', payload: 'RATE_1_' + String(user.id)},
                    { type: 'postback', title: '2', payload: 'RATE_2_' + String(user.id)},
                    { type: 'postback', title: '3', payload: 'RATE_3_' + String(user.id)}
                   ]
        }
      }
    }
    return reply
  end

  def self.execute(args, user)

    puts "?????????"
    
    user2 = User.find(user.talking_to)
    user.talking_to = nil
    user2.talking_to = nil
    user.save
    user2.save
    
    Bot.deliver({
                  recipient: {
                    id: user2.id_fb
                  },
                  message: gen_rating(user),
                }, access_token: ENV['ACCESS_TOKEN'])
    return Reply.new(true, gen_rating(user2))
  end

end
