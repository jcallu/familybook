class AddShortNameToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :short_name, :string
  end
end
