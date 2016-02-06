class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.belongs_to :user, foreign_key: true

      t.string :title
      t.string :github_url

      t.string  :token

      t.timestamps
    end
  end
end
