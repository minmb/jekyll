Feature: Content internationalisation
	As a hacker who likes to blog
	I want to be able to translate my content into different languages
	In order to make my blog famous around the world
	
	@i18n
	Scenario: Translate layout content to page's language
		Given I have a _layouts directory
		And I have a _locales directory
	  And I have an "index.html" page that contains "Basic Site with Layout and Language" with the front matter:
			| key    | value   |
			| layout | default |
			| lang   | en      |
	  And I have a default layout that contains "{% _ layout %}: {{ content }}"
		And I have the following "en" translations:
			| key    | translation   |
			| layout | Page contents |
  	When I run jekyll
  	Then the _site directory should exist
  	And I should see "Page contents: Basic Site with Layout and Language" in "_site/index.html"

	@i18n
	Scenario: Translate page content to page's language
		And I have a _locales directory
	  And I have an "index.html" page with language "en" that contains "{% _ foo %}"
	  And I have an "index.de.html" page with language "de" that contains "{% _ foo %}"
		And I have the following "en" translations:
			| key | translation        |
			| foo | bar is the new foo |
		And I have the following "de" translations:
			| key | translation          |
			| foo | bar ist das neue foo |
  	When I run jekyll
  	Then the _site directory should exist
  	And I should see "bar is the new foo" in "_site/index.html"
  	And I should see "bar ist das neue foo" in "_site/index.de.html"

	@i18n
	Scenario: Translate post content to post's language
	  Given I have a _posts directory
    And I have a _layouts directory
    And I have a _locales directory
    And I have the following post:
      | title          | date      | layout | language | content      |
      | i18n in action | 4/11/2011 | simple | de       | {% _ foo %}. |
    And I have a simple layout that contains "Post content: {{ content }}"
		And I have the following "de" translations:
			| key | translation          |
			| foo | bar ist das neue foo |
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post content: <p>bar ist das neue foo.</p>" in "_site/2011/04/11/i18n-in-action.html"
