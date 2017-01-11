require 'librarian/action'
require 'graphviz'

module Librarian
  module Puppet
    module Action
      class Graph < Librarian::Action::Base
        attr_accessor :dot

        def run
          environment.lock.manifests.each do |manifest|
            n = graph_node(manifest)
            manifest.dependencies.each do |dep|
              d = graph_node(dep)
              n.connect(d)
            end
          end

          @dot = graph.to_dot
        end

        private

        def graph
          if @graph.nil? then
            @graph = Graphviz::Graph.new(:g, :type => :digraph)
          end

          return @graph
        end

        def graph_nodes
          if @graph_nodes.nil? then
            @graph_nodes = {}
          end

          return @graph_nodes
        end

        def graph_node(manifest)
          if graph_nodes[manifest].nil? then
            graph_nodes[manifest] = graph.add_node(manifest.name)
          end

          return graph_nodes[manifest]
        end
      end
    end
  end
end

