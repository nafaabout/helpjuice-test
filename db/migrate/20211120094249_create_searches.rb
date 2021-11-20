# frozen_string_literal: true

class CreateSearches < ActiveRecord::Migration[7.0]
  def change
    create_table :searches do |t|
      t.string :query, null: false
      t.integer :status, default: 0, null: false
      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
