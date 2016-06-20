class HoboMigration1 < ActiveRecord::Migration
  def self.up
    create_table :movimientos do |t|
      t.string   :titular
      t.date     :fecha
      t.string   :numcuenta
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :movimientos
  end
end
