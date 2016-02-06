class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.belongs_to :choice, foreign_key: true
      t.string :token

      t.timestamps
    end
  end
end
