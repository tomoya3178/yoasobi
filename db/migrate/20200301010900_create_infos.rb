class CreateInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :infos do |t|
      t.string :url
      t.string :title
      t.date :date
      t.integer :place_id

      t.timestamps
    end
  end
end
