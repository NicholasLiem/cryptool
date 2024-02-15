class AddKeyToEncryptedFiles < ActiveRecord::Migration[7.1]
  def change
    add_column :encrypted_files, :key, :string, null: false
  end
end
