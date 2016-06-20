class HoboMigration2 < ActiveRecord::Migration
  def self.up
    rename_column :movimientos, :fecha, :fechaop
    add_column :movimientos, :fechavalor, :date
    add_column :movimientos, :codconceptocomun, :string
    add_column :movimientos, :desconceptocomun, :string
    add_column :movimientos, :codconceptopropio, :string
    add_column :movimientos, :clavedh, :string
    add_column :movimientos, :importe, :string
    add_column :movimientos, :saldo, :string
    add_column :movimientos, :documento, :string
    add_column :movimientos, :ref1, :string
    add_column :movimientos, :ref2, :string
    add_column :movimientos, :concepto1, :text
    add_column :movimientos, :concepto2, :text
    add_column :movimientos, :concepto3, :text
    add_column :movimientos, :concepto4, :text
    add_column :movimientos, :concepto5, :text
    add_column :movimientos, :concepto6, :text
    add_column :movimientos, :concepto7, :text
    add_column :movimientos, :concepto8, :text
  end

  def self.down
    rename_column :movimientos, :fechaop, :fecha
    remove_column :movimientos, :fechavalor
    remove_column :movimientos, :codconceptocomun
    remove_column :movimientos, :desconceptocomun
    remove_column :movimientos, :codconceptopropio
    remove_column :movimientos, :clavedh
    remove_column :movimientos, :importe
    remove_column :movimientos, :saldo
    remove_column :movimientos, :documento
    remove_column :movimientos, :ref1
    remove_column :movimientos, :ref2
    remove_column :movimientos, :concepto1
    remove_column :movimientos, :concepto2
    remove_column :movimientos, :concepto3
    remove_column :movimientos, :concepto4
    remove_column :movimientos, :concepto5
    remove_column :movimientos, :concepto6
    remove_column :movimientos, :concepto7
    remove_column :movimientos, :concepto8
  end
end
