require 'telegram/bot'

class TelegramBot
  def initialize
    Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "Привет, #{message.from.first_name}!")
        when '/help'
          bot.api.send_message(chat_id: message.chat.id, text: "Я бот твоего приложения по контролю инструментов, я сообщу если что-то случится в приложении.")
        else
          bot.api.send_message(chat_id: message.chat.id, text: "Извини, я не знаю такой команды.")
        end
      end
    end
  end
end

class TelegramBotService
  def self.send_message(chat_id, text)
    bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])
    bot.api.send_message(chat_id: chat_id, text: text)
  end
end
