class AddSlugToStudio < ActiveRecord::Migration
  def change
    add_column :studios, :slug, :string
  end
end
