class AddNameToSti < ActiveRecord::Migration
  def self.up
    add_column :stis, :name, :string
  end

  def self.down
    remove_column :stis, :name
  end
end
