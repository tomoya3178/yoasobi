class AddFlyerToInfo < ActiveRecord::Migration[5.1]
  def change
    add_column :infos, :flyer, :string, after: :url
  end
end
