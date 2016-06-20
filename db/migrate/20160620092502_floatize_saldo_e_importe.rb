class FloatizeSaldoEImporte < ActiveRecord::Migration
  def self.up
    change_column :movimientos, :importe, :float, :limit => nil
    change_column :movimientos, :saldo, :float, :limit => nil
  end

  def self.down
    change_column :movimientos, :importe, :string
    change_column :movimientos, :saldo, :string
  end
end
