class CreateAgendamentos < ActiveRecord::Migration[8.1]
  def change
    create_table :agendamentos do |t|
      t.references :profissional, null: false, foreign_key: true
      t.references :servico, null: false, foreign_key: true
      t.string :cliente_nome, null: false
      t.string :cliente_email, null: false
      t.string :cliente_telefone
      t.date :data, null: false
      t.time :hora_inicio, null: false
      t.time :hora_fim, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    add_index :agendamentos, [:profissional_id, :data]
  end
end
