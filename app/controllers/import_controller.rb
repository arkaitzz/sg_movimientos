class ImportController < ApplicationController

  def import
    begin
      Movimiento.import(params[:file])
      redirect_to '/movimientos', notice: "CSV procesado"
    end
  end

  def index
    @movimientos = Movimiento.all
  end


end
