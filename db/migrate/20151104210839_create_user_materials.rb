class CreateUserMaterials < ActiveRecord::Migration
  def change
    create_table :user_materials do |t|
      t.references :user, index: true, foreign_key: true
      t.references :material, index: true, foreign_key: true
      t.boolean :discard

      t.timestamps null: false
    end
  end
end
