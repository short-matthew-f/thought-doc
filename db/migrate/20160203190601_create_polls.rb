class CreatePolls < ActiveRecord::Migration[5.0]
  def change
    create_table :polls do |t|
      t.belongs_to :lesson, foreign_key: true

      t.text    :question
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
