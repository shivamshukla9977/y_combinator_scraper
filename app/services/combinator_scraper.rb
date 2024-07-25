# app/services/y_combinator_scraper.rb

require 'httparty'
require 'nokogiri'

class CombinatorScraper
  include HTTParty
  
  BASE_URL = 'https://www.ycombinator.com/companies'

  def initialize(n, filters)
    @n = n
    @filters = filters
    @companies = []
  end

  def scrape
    companies = []
    page = 1
     debugger
    while companies.size < @n
      response = HTTParty.get("#{BASE_URL}?page=#{page}")
      parsed_page = Nokogiri::HTML(response.body)

      parsed_page.css('.styles-module__company___1UVnl').each do |company_node|
        break if companies.size >= @n

        company = extract_company_data(company_node)
        companies << company if company_matches_filters?(company)
      end

      page += 1
    end

    companies
  end

  private

  def extract_company_data(node)
    {
      name: node.at_css('.styles-module__name___2bX-B').text.strip,
      location: node.at_css('.styles-module__location___6Kce6').text.strip,
      description: node.at_css('.styles-module__description___1IwP-').text.strip,
      yc_batch: node.at_css('.styles-module__ycBatch___1Nd6I').text.strip,
      website: node.at_css('.styles-module__link___16xom')['href'],
      founder_names: node.css('.styles-module__founderName___1o12n').map(&:text).join(', '),
      linkedin_urls: node.css('.styles-module__founderLink___2dw-C').map { |link| link['href'] }.join(', ')
    }
  end
end
