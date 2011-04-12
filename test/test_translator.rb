require File.dirname(__FILE__) + '/helper'

class TestTranslator < Test::Unit::TestCase

  context "fast_gettext" do
    setup do
      config = { 'i18n' => 'fast_gettext' }
      @translator = Jekyll::Translator.new(Jekyll::DEFAULTS.merge(config)).setup
    end

    context "#setup" do
      should "not be nil" do
        assert_not_nil @translator
      end
    end
    
    context "#locale=" do
      should "change current locale" do
        language = 'de'
        @translator.locale = language
        assert_equal language, FastGettext.locale
      end
    end
    
    context "#translate" do
      should "translate text (default locale, no translations)" do
        assert_equal FastGettext::Translation::_('test'), @translator.translate('test')
      end

      should "translate text (given locale, no translations)" do
        @translator.locale = 'de'
        assert_equal FastGettext::Translation::_('test'), @translator.translate('test')
      end
    end

    context "#s_ (translate namespaced)" do
      should "translate text (default locale, no translations)" do
        assert_equal FastGettext::Translation::s_('Foo|test'), @translator.s_('Foo|test')
      end

      should "translate text (given locale, no translations)" do
        @translator.locale = 'de'
        assert_equal FastGettext::Translation::s_('Foo|bar|test'), @translator.s_('Foo|bar|test')
      end
    end

    
    context "#locales_dir" do
      should "return the locales directory (absolute path)" do
        assert_equal '/tmp', Jekyll::Translator.new('locales' => '/tmp').locales_dir
      end
      
      should "return the locales directory (relative path)" do
        assert_equal File.expand_path('test'), Jekyll::Translator.new('locales' => 'test').locales_dir
      end

      should "default to './_locales'" do
        assert_equal File.expand_path('_locales'), @translator.locales_dir
      end
    end
    
  end

  context "no localization engine" do
    setup do
      config = { 'i18n' => '' }
      @translator = Jekyll::Translator.new(Jekyll::DEFAULTS.merge(config)).setup
    end

    context "#setup" do
      should "not be nil" do
        assert_not_nil @translator
      end
    end
    
    context "#locale=" do
      should "change current locale" do
        language = 'de'
        @translator.locale = language
        assert_equal language, @translator.locale
      end
    end
    
    context "#translate" do
      should "translate text (default locale, no translations)" do
        assert_equal 'test', @translator.translate('test')
      end

      should "translate text (given locale, no translations)" do
        @translator.locale = 'de'
        assert_equal 'test', @translator.translate('test')
      end
    end
    
    context "#s_ (translate namespaced)" do
      should "translate text (default locale, no translations)" do
        assert_equal 'test', @translator.s_('Foo|test')
      end

      should "translate text (given locale, no translations)" do
        @translator.locale = 'de'
        assert_equal 'test', @translator.s_('Foo|bar|test')
      end
    end
    
  end

end
