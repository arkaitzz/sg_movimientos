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
    if params[:c1]
      case params[:c1]         #https://github.com/activerecord-hackery/ransack
      when '1'
        @search = Movimiento.where('titular LIKE ?', '%arcocha%')
        @search = @search.where('concepto1 LIKE ? OR concepto2 LIKE ? OR concepto3 LIKE ?', '%e3d%', '%e3d%', '%e3d%').ransack
      when '2'
        @search = Movimiento.where('titular LIKE ?', '%arcocha%')
        @search = @search.where('concepto1 LIKE ? OR concepto2 LIKE ? OR concepto3 LIKE ?', '%desvan%', '%desvan%', '%desvan%').ransack
      when '3'
        @search = Movimiento.where('titular LIKE ?', '%e3d%')
        @search = @search.where('concepto1 LIKE ? OR concepto2 LIKE ? OR concepto3 LIKE ?', '%arcocha%', '%arcocha%', '%arcocha%').ransack
      when '4'
        @search = Movimiento.where('titular LIKE ?', '%e3d%')
        @search = @search.where('concepto1 LIKE ? OR concepto2 LIKE ? OR concepto3 LIKE ?', '%desvan%', '%desvan%', '%desvan%').ransack
      when '5'
        @search = Movimiento.where('titular LIKE ?', '%desvan%')
        @search = @search.where('concepto1 LIKE ? OR concepto2 LIKE ? OR concepto3 LIKE ?', '%arcocha%', '%arcocha%', '%arcocha%').ransack
      when '6'
        @search = Movimiento.where('titular LIKE ?', '%desvan%')
        @search = @search.where('concepto1 LIKE ? OR concepto2 LIKE ? OR concepto3 LIKE ?', '%e3d%', '%e3d%', '%e3d%').ransack
      else
        logger.info("ARK: Se ha salido el case")
      end
    end
    @movimientos = @search.result.paginate(:page => params[:page], :per_page => 50)
    movimientos = @search.result
    if params[:q] != {}
      @xls = true
      por_concepto = @movimientos.group("desconceptocomun")
      @concepts = por_concepto.sum('importe')
      ruta_xls = busqueda_movimientos_fichero(movimientos, @concepts)
    end
  end

  def index_2
    @movimientos = Movimiento.where('titular LIKE ? AND concepto1 LIKE ? OR concepto2 LIKE ? OR concepto3 LIKE ?', '%desvan%', '%arkaitz%', '%arkaitz%', '%arkaitz%')
  hobo_index
  end

  def descarga_xls
    send_file 'app/attachments/documents/lista_movimientos.xls' , :type => 'application/vnd.ms-excel'
  end


  # Genera XLS
  def busqueda_movimientos_fichero(movimientos_busqueda, resumen)
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
    worksheet.column(21).width = 5
    worksheet.column(22).width = 70

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
      columna = 22
      for inverso in movimiento.inverso
      worksheet[fila, columna] = inverso.detalle_movimiento
        columna += 1
      end
    end
      fila += 5
      worksheet[fila,5] = 'Concepto'
      worksheet[fila,6] = 'Suma de importes'
    resumen.each do |key, value|
      fila += 1
      worksheet[fila,5] = key.to_s
      worksheet[fila,6] = "%5.2f" % value
    end
    workbook.write "app/attachments/documents/lista_movimientos.xls"
    return "app/attachments/documents/lista_movimientos.xls"
  end

  def eliminar_duplicados
    grouped = Movimiento.all.group_by{|movimiento| [movimiento.titular, movimiento.fechaop, movimiento.fechavalor, movimiento.importe, movimiento.saldo] }
    count = grouped.count
    grouped.values.each do |duplicates|
      # the first one we want to keep
      first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each{|double| double.destroy} # duplicates can now be destroyed
    end
      redirect_to '/movimientos', notice: "#{count.to_s} registros únicos. Los demás se han eliminado."
  end

end

