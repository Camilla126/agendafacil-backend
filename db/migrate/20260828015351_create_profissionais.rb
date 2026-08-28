class CreateProfissionais < ActiveRecord::Migration[8.1]
  def change
    create_table :profissionais do |t|
      t.string :nome, null: false
      t.string :email, null: false
      t.string :senha_digest, null: false
      t.string :slug, null: false

      t.timestamps
    end
    add_index :profissionais, :email, unique: true
    add_index :profissionais, :slug, unique: true
  end
end
