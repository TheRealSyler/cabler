# SPDX-FileCopyrightText: 2020 Felix Wolfsteller
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class TopologyController < ApplicationController
  before_action :authenticate_user!

  # GET /dashboard
  def show
    @graph_configuration = GraphConfiguration.new(graph_configuration_params)
    g = Graph.new rankdir: @graph_configuration.rank_dir,
      splines:       @graph_configuration.splines,
      box_locations: @graph_configuration.box_locations,
      show_ports:    @graph_configuration.show_ports.to_sym

    respond_to do |format|
      format.html { @png = g.to_png }
      format.png { render plain: g.to_png } # send_data , type: 'image/png', disposition: 'inline'
      format.svg { render plain: g.to_svg }
      format.dot { send_data g.to_dot,
                     filename: 'cabler_graph.dot',
                     type: 'text/plain',
                     disposition: 'attachment'
                 }
    end
  end

  private
  def graph_configuration_params
    params.fetch(:graph_configuration, {}).permit(
      :rank_dir, :show_locations, :location_shape, :device_shape, :box_locations, :splines, :show_ports
    )
  end
end
