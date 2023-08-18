#begin
  #require "factory_bot_rails"
#rescue LoadError
#end

module BulletTrain
  module Billing
    class Engine < ::Rails::Engine
      #if defined? FactoryBotRails
        #config.factory_bot.definition_file_paths += [File.expand_path("../../../factories", __FILE__)]
      #end
    end
  end
end
