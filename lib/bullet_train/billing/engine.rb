begin
  require "factory_bot_rails"
rescue LoadError
end

module BulletTrain
  module Billing
    class Engine < ::Rails::Engine
      if defined? FactoryBotRails
        # TODO: We should probably move the factories out of the test directory and into lib so that we can
        # ship them for use by consuming apps. For now this works when linking against a local copy.
        config.factory_bot.definition_file_paths += [File.expand_path("../../../../test/factories", __FILE__)]
      end
    end
  end
end
