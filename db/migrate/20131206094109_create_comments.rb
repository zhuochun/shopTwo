class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :product, index: true
      t.integer :rating, default: 3
      t.string :flag, default: 'approved'
      t.text :content

      t.timestamps
    end
  end
end
