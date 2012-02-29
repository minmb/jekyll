module Jekyll
  class Translator < Plugin
    safe true
    
    # Initialize the translator.
    #
    # Returns an initialized Translator.
    def initialize(config)
      @config = config || {}
    end
    
    def setup
      return self if @setup
      
      case @config['i18n'].to_s
        when ''
          # do nothing
        when /fast_gettext/i
          begin
            require 'fast_gettext'

            FastGettext.add_text_domain('jekyll', :path => locales_dir, :type => :yaml)
            FastGettext.default_text_domain = 'jekyll'
            FastGettext.locale = @config['language'] || @config['lang'] || locale
            
          rescue LoadError
            handle_load_error_for('fast_gettext')
          end
        else
          STDERR.puts "Invalid i18n engine: #{@config['i18n']}"
          STDERR.puts "  Valid options are [ nil | fast_gettext ]"
          raise FatalException.new("Invalid i18n engine: #{@config['i18n']}")
      end
      
      @setup = true
      self
    end

    # Returns the path to the directory from where Jekyll loads locale translations.
    def locales_dir
      @locales_dir ||= File.expand_path(@config['locales'] || '_locales')
    end
    
    # Returns the current locale.
    def locale
      case @config['i18n']
        when /fast_gettext/i
          FastGettext.locale
        else
          @locale ||= 'en'
      end
    end
    
    # Set the current locale to new_locale.
    def locale=(new_locale)
      return locale if new_locale.to_s == ''
      
      case @config['i18n']
        when /fast_gettext/i
          FastGettext.locale = new_locale
        else
          @locale = new_locale
      end
    end

    # Returns a translation of the given text.
    def translate(text)
      case @config['i18n']
        when /fast_gettext/i
          FastGettext::Translation::_(text)
        else
          text
      end
    end

    alias :t :translate    
    alias :_ :translate
    
    def n_(*keys)
      case @config['i18n']
        when /fast_gettext/i
          FastGettext::Translation::n_(*keys)
        else
          keys.join
      end
    end
    
    def s_(key)
      case @config['i18n']
        when /fast_gettext/i
          FastGettext::Translation::s_(key)
        else
          key.split(/\|/).last
      end
    end
    
    protected
    
    def handle_load_error_for(library)
      STDERR.puts 'You are missing a library required for i18n support. Please run:'
      STDERR.puts "  $ [sudo] gem install #{library}"
      raise FatalException.new("Missing dependency: #{library}")            
    end
    
  end
end
