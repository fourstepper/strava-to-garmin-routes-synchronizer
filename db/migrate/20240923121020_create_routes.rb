class CreateRoutes < ActiveRecord::Migration[7.2]
  def change
    create_table :routes do |t|
      t.string :name
      t.datetime :route_updated_at
      t.integer :route_id
      t.string :gpx
      t.boolean :process
      t.boolean :exists_in_connect

      t.timestamps
    end
  end
end
