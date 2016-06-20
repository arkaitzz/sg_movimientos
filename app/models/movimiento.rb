class Movimiento < ActiveRecord::Base

  hobo_model # Don't put anything above this

  require 'csv'

  fields do
    numcuenta :string
    titular   :string
    fechaop     :date
    fechavalor     :date
    codconceptocomun :string
    desconceptocomun :string
    codconceptopropio :string
    clavedh   :string
    importe   :string
    saldo     :string
    documento :string
    ref1      :string
    ref2      :string
    concepto1   :text
    concepto2   :text
    concepto3   :text
    concepto4   :text
    concepto5   :text
    concepto6   :text
    concepto7   :text
    concepto8   :text

    timestamps
  end
  attr_accessible :titular, :fechaop, :numcuenta, :fechavalor, :codconceptocomun, :desconceptocomun, 
                  :codconceptopropio, :clavedh, :importe, :saldo , :documento, :ref1, :ref2, 
                  :concepto1, :concepto2, :concepto3, :concepto4, :concepto5, :concepto6, :concepto7, :concepto8

  # --- Includes --- #
  include HoboSerenity

#  def self.importX(file)
#    CSV.foreach(file.path, headers: true) do |row|
#      logger.info("ARK row:"+ row.inspect)
#      product_hash = row.to_hash # exclude the price field
#      product = Movimiento.where(id: product_hash["id"])

#      if product.count == 1
#        product.first.update_attributes(product_hash)
#      else
#        Movimiento.create!(product_hash)
#      end # end if !product.nil?
#    end # end CSV.foreach
#  end # end self.import(file)


  def self.import(file)
    csv = CSV.open(file.path, "r:ISO-8859-15:UTF-8", {:col_sep => ";", :headers => :first_row})
    csv.each do |row|
      a = row.to_hash
      logger.info("ARK row to jas a insertar:"+ a['NumCuenta'].to_s)
      next if a['NumCuenta'] == nil
      #Campos fecha
      fechaop = Date.new(2000+a['FechaOperacion'][6..7].to_i, a['FechaOperacion'][3..4].to_i, a['FechaOperacion'][0..1].to_i)
      fechavalor = Date.new(2000+a['FechaValor'][6..7].to_i, a['FechaValor'][3..4].to_i, a['FechaValor'][0..1].to_i)
      # Campos float 1ro le quitamos los puntos si los tiene, el de los millares, despues sustituimos las comas de los decimales por puntos 
      # y finalmente si tiene el - se lo ponemos delante
      importe=a['Importe']
      if importe.include? '.'
        importe=importe.sub!('.','')
      end
      importe=importe.sub!(',','.')
      if importe.include? '-'
        importe.sub!('-','')
        importe = '-'+importe
      end

      saldo=a['Saldo']
      if saldo.include? '.'
        saldo=saldo.sub!('.','')
      end
      saldo=a['Saldo'].sub!(',','.')
      if saldo.include? '-'
        saldo.sub!('-','')
        saldo = '-'+saldo
      end
      Movimiento.create :numcuenta => a['NumCuenta'], :titular => a['Titular'], :fechaop => fechaop, :fechavalor => fechavalor, 
        :codconceptocomun => a['CodConceptoComun'], :desconceptocomun => a['DesConceptoComun'], :codconceptopropio => a['CodConceptoPropio'],
        :clavedh => a['ClaveDH'], :importe => importe, :saldo => saldo, :documento => a['Documento'],
        :ref1 => a['Referencia1'], :ref2 => a['Referencia2'], :concepto1 => a['Concepto1'], :concepto2 => a['Concepto2'], :concepto3 => a['Concepto3'], 
        :concepto4 => a['Concepto4'], :concepto5 => a['Concepto5'], :concepto6 => a['Concepto6'], :concepto7 => a['Concepto7'], :concepto8 => a['Concepto8']
    end
  end

  #  def make_a_date(datestring)
  #    dia = datestring[0..1].to_i
  #    mes = datestring[3..4].to_i
  #    ano = 2000+datestring[6..7].to_i
  #    f = Date.new(ano, mes, dia)
  #    return f
  #  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator?
  end

end
