class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :oauth_token
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
