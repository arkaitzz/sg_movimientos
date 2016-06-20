# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160619192031) do

  create_table "movimientos", force: true do |t|
    t.string   "titular"
    t.date     "fechaop"
    t.string   "numcuenta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "fechavalor"
    t.string   "codconceptocomun"
    t.string   "desconceptocomun"
    t.string   "codconceptopropio"
    t.string   "clavedh"
    t.string   "importe"
    t.string   "saldo"
    t.string   "documento"
    t.string   "ref1"
    t.string   "ref2"
    t.text     "concepto1"
    t.text     "concepto2"
    t.text     "concepto3"
    t.text     "concepto4"
    t.text     "concepto5"
    t.text     "concepto6"
    t.text     "concepto7"
    t.text     "concepto8"
  end

  create_table "users", force: true do |t|
    t.string   "crypted_password",          limit: 40
    t.string   "salt",                      limit: 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                default: "invited"
    t.datetime "key_timestamp"
  end

  add_index "users", ["state"], name: "index_users_on_state"

end