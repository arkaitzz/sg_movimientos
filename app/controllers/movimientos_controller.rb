class MovimientosController < ApplicationController

  hobo_model_controller

  auto_actions :all

  # Hobo-Serenity
  include HoboSerenityController
  # XLS file creation
  require 'spreadsheet'
  include Spreadsheet

  # The index is redefined in order to be usable for the gem hobo_metasearch
  def index
    @xls = false
    params[:q] = {} if !params[:q]
    @search = Movimiento.search(params[:q])
    @movimientos = @search.result.paginate(:page => params[:page], :per_page => 50)
    movimientos = @search.result
    if params[:q] != {}
      @xls = true
      ruta_xls = busqueda_movimientos_fichero(movimientos)
    end
  end

  def descarga_xls
    send_file 'app/attachments/documents/lista_movimientos.xls' , :type => 'application/vnd.ms-excel'
  end


  # Genera XLS
  def busqueda_movimientos_fichero(movimientos_busqueda)
    workbook = Spreadsheet.open 'app/attachments/xls_templates/busqueda_movimientos.xls'
    worksheet = workbook.worksheet 'Movimientos'
    # Aspecto del XLS
    heading = Format.new(
       :color     => "green",
       :bold      => true,
       :underline => true,
       :size => 8
    )
    general = Spreadsheet::Format.new(
       :size => 5,
       :text_wrap => true
    )
    worksheet.row(1).height = 100
    worksheet.default_format = general
    worksheet.column(0).width = 20
    worksheet.column(1).width = 30
    worksheet.column(2).width = 11
    worksheet.column(3).width = 11
    worksheet.column(4).width = 7
    worksheet.column(5).width = 50
    worksheet.column(6).width = 7
    worksheet.column(7).width = 7
    worksheet.column(8).width = 10
    worksheet.column(9).width = 10
    worksheet.column(10).width = 20
    worksheet.column(11).width = 20
    worksheet.column(12).width = 20
    worksheet.column(13).width = 50
    worksheet.column(14).width = 50
    worksheet.column(15).width = 50
    worksheet.column(16).width = 50
    worksheet.column(17).width = 50
    worksheet.column(18).width = 50
    worksheet.column(19).width = 50
    worksheet.column(20).width = 50

    fila = 1
    for movimiento in movimientos_busqueda
      fila += 1
      worksheet.row(fila).set_format(fila, general)
      worksheet[fila,0] = movimiento.numcuenta
      worksheet[fila,1] = movimiento.titular
      worksheet[fila,2] = movimiento.fechaop.to_s
      worksheet[fila,3] = movimiento.fechavalor.to_s
      worksheet[fila,4] = movimiento.codconceptocomun
      worksheet[fila,5] = movimiento.desconceptocomun
      worksheet[fila,6] = movimiento.codconceptopropio
      worksheet[fila,7] = movimiento.clavedh
      worksheet[fila,8] = movimiento.importe.to_s
      worksheet[fila,9] = movimiento.saldo.to_s
      worksheet[fila,10] = movimiento.documento
      worksheet[fila,11] = movimiento.ref1
      worksheet[fila,12] = movimiento.ref2
      worksheet[fila,13] = movimiento.concepto1
      worksheet[fila,14] = movimiento.concepto2
      worksheet[fila,15] = movimiento.concepto3
      worksheet[fila,16] = movimiento.concepto4
      worksheet[fila,17] = movimiento.concepto5
      worksheet[fila,18] = movimiento.concepto6
      worksheet[fila,19] = movimiento.concepto7
      worksheet[fila,20] = movimiento.concepto8
    end
    workbook.write "app/attachments/documents/lista_movimientos.xls"
    return "app/attachments/documents/lista_movimientos.xls"
  end

end

