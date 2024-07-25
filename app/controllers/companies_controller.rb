class CompaniesController < ApplicationController
  def index
    n = params[:n].to_i
    filters = params[:filters] || {}
    
    scraper = CombinatorScraper.new(n, filters)
    companies = scraper.scrape

    respond_to do |format|
      format.json { render json: companies }
      format.csv { send_data generate_csv(companies), filename: "companies-#{Date.today}.csv" }
    end
  end

  private

  def generate_csv(companies)
    CSV.generate(headers: true) do |csv|
      csv << %w[name location description yc_batch website founder_names linkedin_urls]
      companies.each do |company|
        csv << company.values
      end
    end
  end
end
