class DatabaseDecorator < ResourceDecorator
  decorates :database

  def pretty_nodes
    html = "<strong>#{h.link_to model.name, model}</strong>"
    if model.servers.any? && model.servers.map(&:name) != [model.name]
      html << %(<ul class="database_nodes">)
      html << model.servers.map(&:name).sort.map{|n| "<li>#{n}</li>"}.join("\n")
      html << "</ul>"
    end
    html.html_safe
  end
end
#### encoding: utf-8

###require 'server_decorator'

###module DatabasesHelper
###  include SizeHelper

###  def database_headers_for(database_type)
###    if database_type == "postgres"
###      %(<th>IP</th>
###        <th>Port</th>
###        <th>PgCluster</th>
###        <th style="text-align:left;">Bases<span style="float:right;padding-left:1em">Taille(Go)</span></th>).html_safe
###    elsif database_type == "oracle"
###      %(<th>IP</th>
###        <th>Port</th>
###        <th>Instance</th>
###        <th style="text-align:left;">Schémas<span style="float:right;padding-left:1em">Taille(Go)</span></th>).html_safe
###    end
###  end

###  def databases_summary(databases)
###    return "" if databases.blank?
###    total_size = databases.values.sum
###    top_databases = databases.select do |db,size|
###      size >= total_size / 6
###    end.keys
###    if top_databases.size == 0
###      top_databases = databases.sort_by do |db,size|
###        size
###      end.reverse.map do |a|
###        a[0]
###      end.first(2)
###    end
###    html = %(#{top_databases.join(", ")})
###    html << %(,&nbsp;...) if top_databases.size < databases.size
###    html << %(<span style="float:right; padding-left:1em">#{display_size(total_size)}</span>)
###    html.html_safe
###  end