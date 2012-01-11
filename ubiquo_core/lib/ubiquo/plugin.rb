module Ubiquo
  class Plugin

    cattr_accessor :registered

    self.registered ||= {}

    def setting(*args)      
      Ubiquo::Settings.add(args)
    end

    def self.register(name, &block)
      if name.present?
        Ubiquo::Settings.create_context(name)
        Ubiquo::Settings.context(name, &block)      
      else
        yield Ubiquo::Settings if block_given

      end
      self.registered[name] = name

    end

  end

  class PluginSpec

    class MissingName < StandardError; end
    class MissingVersion < StandardError; end

    attr_accessor :name, :version, :url, :desc, :dependencies

    def initialize(&block)
      @url = @desc = ''
      @dependencies = {}
      yield self
      raise MissingName unless name
      raise MissingVersion unless version
    end
  end
end
