class CreateRoutes < ActiveRecord::Migration[7.2]
  def change
    create_table :routes do |t|
      t.string :name
      t.datetime :timestamp
      t.json :json

      t.timestamps
    end
  end
end
