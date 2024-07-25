class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :location
      t.text :description
      t.string :yc_batch
      t.string :website
      t.text :founder_names
      t.text :linkedin_urls

      t.timestamps
    end
  end
end
