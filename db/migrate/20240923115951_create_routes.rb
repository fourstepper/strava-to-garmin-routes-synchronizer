class CreateRoutes < ActiveRecord::Migration[7.2]
  def change
    create_table :routes do |t|
      t.string :name
      t.datetime :timestamp_updated_at

      t.timestamps
    end
  end
end
