require 'fast_gettext'

# require 'ruby-debug'
# Debugger.start


module Jekyll
  class TranslateTag < Liquid::Tag
    
    def initialize(tag_name, text, tokens)
      super
      @text = text.strip
    end

    def render(context)
      site = context.registers[:site]
      page = context['page']
      locales = File.expand_path(site.config['locales'] || '_locales')

      FastGettext.add_text_domain('jekyll', :path => locales, :type => :yaml)
      FastGettext.text_domain = 'jekyll'
      FastGettext.locale = page && page['language'] || page['lang'] || 'en' 

      FastGettext::Translation::_(@text)
    end
  end
end

Liquid::Template.register_tag('_', Jekyll::TranslateTag)
Liquid::Template.register_tag('t', Jekyll::TranslateTag)
Liquid::Template.register_tag('translate', Jekyll::TranslateTag)