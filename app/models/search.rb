class Search < ApplicationRecord

  validates :address1, presence: true
  validates :restaurant, presence: true

  after_initialize do |search|
    scrapeGrubHub(search)
  end

  def scrapeGrubHub(search)
    agent = Mechanize.new
    page = agent.get('http://grubhub.com/')
    pp page
  end


end
