# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_28_015754) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "agendamentos", force: :cascade do |t|
    t.string "cliente_email", null: false
    t.string "cliente_nome", null: false
    t.string "cliente_telefone"
    t.datetime "created_at", null: false
    t.date "data", null: false
    t.time "hora_fim", null: false
    t.time "hora_inicio", null: false
    t.bigint "profissional_id", null: false
    t.bigint "servico_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["profissional_id", "data"], name: "index_agendamentos_on_profissional_id_and_data"
    t.index ["profissional_id"], name: "index_agendamentos_on_profissional_id"
    t.index ["servico_id"], name: "index_agendamentos_on_servico_id"
  end

  create_table "disponibilidades", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "dia_semana", null: false
    t.time "hora_fim", null: false
    t.time "hora_inicio", null: false
    t.bigint "profissional_id", null: false
    t.datetime "updated_at", null: false
    t.index ["profissional_id", "dia_semana"], name: "index_disponibilidades_on_profissional_id_and_dia_semana"
    t.index ["profissional_id"], name: "index_disponibilidades_on_profissional_id"
  end

  create_table "profissionais", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "nome", null: false
    t.string "senha_digest", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_profissionais_on_email", unique: true
    t.index ["slug"], name: "index_profissionais_on_slug", unique: true
  end

  create_table "servicos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "duracao_minutos", null: false
    t.string "nome", null: false
    t.bigint "profissional_id", null: false
    t.datetime "updated_at", null: false
    t.decimal "valor", precision: 10, scale: 2
    t.index ["profissional_id"], name: "index_servicos_on_profissional_id"
  end

  add_foreign_key "agendamentos", "profissionais"
  add_foreign_key "agendamentos", "servicos"
  add_foreign_key "disponibilidades", "profissionais"
  add_foreign_key "servicos", "profissionais"
end
