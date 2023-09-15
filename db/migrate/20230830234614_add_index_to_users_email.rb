# frozen_string_literal: true

class AddIndexToUsersEmail < ActiveRecord::Migration[7.0]
  def change
    # set email to unique
    add_index :users, :email, unique: true
  end
end
