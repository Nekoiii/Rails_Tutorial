# frozen_string_literal: true

class CreateMicroposts < ActiveRecord::Migration[7.0]
  def change
    create_table :microposts do |t|
      t.text :content
      t.integer :user_id, null: false, foreign_key: true

      t.timestamps
    end

    # Multiple Key Index
    # For faster retrieval of microposts by user and date.
    add_index :microposts, %i[user_id created_at]
  end
end
