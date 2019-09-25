class Search < ApplicationRecord

  validates :address1, presence: true
  validates :restaurant, presence: true

  after_initialize do |search|
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


end
