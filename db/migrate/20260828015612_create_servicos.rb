class CreateServicos < ActiveRecord::Migration[8.1]
  def change
    create_table :servicos do |t|
      t.references :profissional, null: false, foreign_key: true
      t.string :nome, null: false
      t.integer :duracao_minutos, null: false
      t.decimal :valor, precision: 10, scale: 2

      t.timestamps
    end
  end
end
