class MovimientosController < ApplicationController

  hobo_model_controller

  auto_actions :all

  # Hobo-Serenity
  include HoboSerenityController

  # The index is redefined in order to be usable for the gem hobo_metasearch
  def index
    params[:q] = {} if !params[:q]
    @search = Movimiento.search(params[:q])
    @movimientos = @search.result.paginate(:page => params[:page], :per_page => 50)
  end

end
