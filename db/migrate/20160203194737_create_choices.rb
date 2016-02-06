class CreateChoices < ActiveRecord::Migration[5.0]
  def change
    create_table :choices do |t|
      t.belongs_to :poll, foreign_key: true
      
      t.text :content
      t.boolean :correct, default: false

      t.timestamps
    end
  end
end
