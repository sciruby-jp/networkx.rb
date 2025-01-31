module NetworkX
  # Returns the descendants of a given node
  #
  # @param graph [Graph, DiGraph, MultiGraph, MultiDiGraph] a graph
  # @param source [Object] node to find descendents of
  #
  # @return [Array<Object>] Array of the descendants
  def self.descendants(graph, source)
    raise ArgumentError, 'Source is not present in the graph!' unless graph.node?(source)

    des = single_source_shortest_path_length(graph, source).map { |u, _| u }.uniq
    des - [source]
  end

  # Returns the ancestors of a given node
  #
  # @param graph [Graph, DiGraph, MultiGraph, MultiDiGraph] a graph
  # @param source [Object] node to find ancestors of
  #
  # @return [Array<Object>] Array of the ancestors
  def self.ancestors(graph, source)
    raise ArgumentError, 'Source is not present in the graph!' unless graph.node?(source)

    anc = single_source_shortest_path_length(graph.reverse, source).map { |u, _| u }.uniq
    anc - [source]
  end

  # Returns the nodes arranged in the topologically sorted fashion
  #
  # @param graph [DiGraph] a graph
  #
  # @return [Array<Object>] Array of the nodes
  def self.topological_sort(graph)
    raise ArgumentError, 'Topological Sort not defined on undirected graphs!' unless graph.directed?

    nodes = []
    indegree_map = graph.nodes.each_key.map do |u|
      [u, graph.in_degree(u)] if graph.in_degree(u).positive?
    end.compact.to_h
    zero_indegree = graph.nodes.each_key.select { |u| graph.in_degree(u).zero? }

    until zero_indegree.empty?
      node = zero_indegree.shift
      raise ArgumentError, 'Graph changed during iteration!' unless graph.nodes.has_key?(node)

      graph.adj[node].each_key do |child|
        indegree_map[child] -= 1
        if indegree_map[child].zero?
          zero_indegree << child
          indegree_map.delete(child)
        end
      end
      nodes << node
    end
    raise ArgumentError, 'Graph contains cycle or graph changed during iteration!' unless indegree_map.empty?

    nodes
  end
end
