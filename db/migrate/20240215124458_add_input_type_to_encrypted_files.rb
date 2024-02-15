class AddInputTypeToEncryptedFiles < ActiveRecord::Migration[7.1]
  def change
    add_column :encrypted_files, :input_type, :string, default: 'Text', null: false
  end
end
