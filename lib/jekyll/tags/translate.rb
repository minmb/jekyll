module Jekyll
  class TranslateTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text.strip
    end

    def render(context)
      context.registers[:site].translator._(@text)
    end
  end

  class TranslatePluralizedTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @keys = text.strip.split(/,\s*/)
    end

    def render(context)
      context.registers[:site].translator.n_(*@keys)
    end
  end

  class TranslateNamespaceTag < TranslateTag
    def render(context)
      context.registers[:site].translator.s_(@text)
    end
  end
end

Liquid::Template.register_tag('_', Jekyll::TranslateTag)
Liquid::Template.register_tag('t', Jekyll::TranslateTag)
Liquid::Template.register_tag('translate', Jekyll::TranslateTag)
Liquid::Template.register_tag('n_', Jekyll::TranslatePluralizedTag)
Liquid::Template.register_tag('s_', Jekyll::TranslateNamespaceTag)
