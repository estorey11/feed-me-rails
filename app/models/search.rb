require 'uri'

class Search < ApplicationRecord

  validates :address1, presence: true
  validates :restaurant, presence: true

  after_initialize do |search|
    scrapePostmates(search)
    @ghResult= scrapeGrubHub(search)
    self.ghName=@ghResult[0]
    self.ghUrl=@ghResult[1]

  end

  def scrapeGrubHub(search)
    @options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
    @driver = Selenium::WebDriver.for(:chrome)

    @driver.get('https://www.grubhub.com')

    @element = @driver.find_element(class: 'addressInput-textInput')
    @address="#{search.address1}, #{search.city}, #{search.state}, #{search.zip}"
    @element.send_keys(@address)

    @driver.find_element(id: 'ghs-loggedOut-startOrderBtn').click

    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    @wait.until { @driver.find_element(:id => "search-autocomplete-input") }

    @element = @driver.find_element(id: 'search-autocomplete-input')
    @element.send_keys(search.restaurant)
    @element.send_keys(:return)

    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    @wait.until { @driver.find_element(:class => "restaurant-name") }

    @element = @driver.find_element(:class => "restaurant-name")
    @searchResult= [@element.attribute("title"), @element.attribute("href")]
    @driver.quit

    @searchResult
  end

  def scrapePostmates(search)
    @options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
    @driver = Selenium::WebDriver.for(:chrome)

    @driver.get('https://www.postmates.com')

    @element = @driver.find_element(id: 'e2e-geosuggest-input')
    @address="#{search.address1}, #{search.city}, #{search.state}, #{search.zip}"
    @element.send_keys(@address)

    @driver.find_element(id: 'e2e-go-button').click

    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    @wait.until { @driver.find_element(:class => "css-8kori2") }

    @driver.get("https://postmates.com/search?q=#{URI::encode(search.restaurant)}")

    @elements = @driver.find_elements(tag_name: 'span')
    @name=@elements[8].text

    @elements = @driver.find_elements(tag_name: 'a')
    binding.pry
    @elements.each_with_index{|element, i| puts "#{i} #{@element.attribute("href")}"}

    #@searchResult= [@element.attribute("title"), @element.attribute("href")]
    @driver.quit

    #@searchResult
  end


end
