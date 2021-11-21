# frozen_string_literal: true

class AddRoleToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer, default: 0, null: false
    remove_column :users, :is_guest, :boolean, default: true
  end
end
