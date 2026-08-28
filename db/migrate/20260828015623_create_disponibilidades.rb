class CreateDisponibilidades < ActiveRecord::Migration[8.1]
  def change
    create_table :disponibilidades do |t|
      t.references :profissional, null: false, foreign_key: true
      t.integer :dia_semana, null: false
      t.time :hora_inicio, null: false
      t.time :hora_fim, null: false

      t.timestamps
    end
    add_index :disponibilidades, [:profissional_id, :dia_semana]
  end
end
