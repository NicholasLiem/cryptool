class CreateEncryptedFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :encrypted_files do |t|
      t.string :name
      t.string :file_path
      t.string :algorithm

      t.timestamps
    end
  end
end
