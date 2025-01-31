RSpec.describe NetworkX::Graph do
  subject { graph }

  let(:graph1) { described_class.new(type: 'undirected') }
  let(:graph2) { described_class.new(type: 'undirected') }

  before do
    graph1.add_edge(1, 2)
    graph2.add_edge(5, 6)
  end

  context 'when union is called' do
    subject { NetworkX.union(graph1, graph2) }

    its('adj') do
      is_expected.to eq(1 => {2 => {}},
                        2 => {1 => {}},
                        5 => {6 => {}},
                        6 => {5 => {}})
    end
  end

  it 'unite DiGraph' do
    graph1 = NetworkX::DiGraph.new
    graph2 = NetworkX::DiGraph.new
    graph1.add_edge(1, 2)
    graph1.add_edge(2, 3)
    graph2.add_edge(5, 6)

    graph3 = NetworkX.union(graph1, graph2)
    expect(graph3.class).to be NetworkX::DiGraph
    expect(graph3.number_of_nodes).to be 5
    expect(graph3.number_of_edges).to be 3
    expect(graph3.has_node?(2)).to be true
    expect(graph3.has_node?(5)).to be true
    expect(graph3.has_edge?(5, 6)).to be true
  end

  it 'unite Graph' do
    graph1 = NetworkX::Graph.new
    graph2 = NetworkX::Graph.new
    graph1.add_edge(:a, :b)
    graph1.add_edge(:b, :c)
    graph2.add_edge(:e, :f)

    graph3 = NetworkX.union(graph1, graph2)
    expect(graph3.class).to be NetworkX::Graph
    expect(graph3.number_of_nodes).to be 5
    expect(graph3.number_of_edges).to be 3
    expect(graph3.has_node?(:b)).to be true
    expect(graph3.has_node?(:e)).to be true
    expect(graph3.has_edge?(:e, :f)).to be true
  end

  it 'unite MultiGraph' do
    graph1 = NetworkX::MultiGraph.new
    graph2 = NetworkX::MultiGraph.new
    graph1.add_edge(1, 2)
    graph1.add_edge(2, 3)
    graph2.add_edge(5, 6)

    graph3 = NetworkX.union(graph1, graph2)
    expect(graph3.class).to be NetworkX::MultiGraph
    expect(graph3.number_of_nodes).to be 5
    expect(graph3.number_of_edges).to be 3
    expect(graph3.has_node?(2)).to be true
    expect(graph3.has_node?(5)).to be true
    expect(graph3.has_edge?(5, 6)).to be true
  end

  it 'unite MultiDiGraph' do
    graph1 = NetworkX::MultiDiGraph.new
    graph2 = NetworkX::MultiDiGraph.new
    graph1.add_edge(1, 2)
    graph1.add_edge(2, 3)
    graph2.add_edge(5, 6)

    graph3 = NetworkX.union(graph1, graph2)
    expect(graph3.class).to be NetworkX::MultiDiGraph
    expect(graph3.number_of_nodes).to be 5
    expect(graph3.number_of_edges).to be 3
    expect(graph3.has_node?(2)).to be true
    expect(graph3.has_node?(5)).to be true
    expect(graph3.has_edge?(5, 6)).to be true
  end

  context 'when disjoint_union is called' do
    subject { NetworkX.disjoint_union(graph1, graph2) }

    its('adj') do
      is_expected.to eq('10' => {'21' => {}},
                        '21' => {'10' => {}},
                        '50' => {'61' => {}},
                        '61' => {'50' => {}})
    end
  end

  context 'when compose is called' do
    subject { NetworkX.compose(graph1, graph2) }

    its('adj') do
      is_expected.to eq(1 => {2 => {}},
                        2 => {1 => {}},
                        5 => {6 => {}},
                        6 => {5 => {}})
    end
  end

  it 'compose multiple graphs' do
    graph1 = NetworkX::MultiDiGraph.new(name: 'first')
    graph2 = NetworkX::MultiDiGraph.new(name: 'second')
    graph1.add_nodes_from(0...5)
    graph2.add_nodes_from(2...6)

    graph1.add_edge(0, 1)
    graph1.add_edge(1, 2)
    graph2.add_edge(0, 1)
    graph2.add_edge(4, 5)
    graph2.add_edge(4, 5)

    graph3 = NetworkX.compose(graph1, graph2)
    expect(graph3.class).to be NetworkX::MultiDiGraph
    expect(graph3.number_of_nodes).to be 6
    expect(graph3.number_of_edges).to be 5
  end

  context 'when symmetric_difference is called' do
    subject { NetworkX.symmetric_difference(graph1, graph2) }

    before do
      graph2.clear
      graph2.add_node(1)
      graph2.add_node(2)
    end

    its('adj') { is_expected.to eq(1 => {2 => {}}, 2 => {1 => {}}) }
  end

  it 'intersection for Graph' do
    g = NetworkX::Graph.new
    h = NetworkX::Graph.new
    g.add_edges_from([[0, 1], [0, 2], [1, 2], [1, 3]])
    h.add_edges_from([[0, 1], [1, 2], [0, 3]])
    new_graph = NetworkX.intersection(g, h)
    expect(new_graph.nodes).to eq({0 => {}, 1 => {}, 2 => {}, 3 => {}})
    expect(new_graph.number_of_nodes).to be 4
    expect(new_graph.number_of_edges).to be 2
    expect(new_graph.adj).to eq({
                                  0 => {1 => {}},
                                  1 => {0 => {}, 2 => {}},
                                  2 => {1 => {}},
                                  3 => {}
                                })
  end

  it 'intersection for MultiGraph' do
    g = NetworkX::MultiGraph.new
    h = NetworkX::MultiGraph.new
    g.add_edges_from([[0, 1], [0, 2], [1, 2], [1, 3]])
    h.add_edges_from([[0, 1], [1, 2], [0, 3]])
    new_graph = NetworkX.intersection(g, h)
    expect(new_graph.nodes).to eq({0 => {}, 1 => {}, 2 => {}, 3 => {}})
    expect(new_graph.number_of_nodes).to be 4
    expect(new_graph.number_of_edges).to be 2
    expect(new_graph.adj).to eq({
                                  0 => {1 => {0 => {}}},
                                  1 => {0 => {0 => {}}, 2 => {0 => {}}},
                                  2 => {1 => {0 => {}}},
                                  3 => {}
                                })
  end

  it 'intersection for MultiDiGraph' do
    g = NetworkX::MultiDiGraph.new
    h = NetworkX::MultiDiGraph.new
    g.add_edges_from([[0, 1], [0, 2], [1, 2], [1, 3]])
    h.add_edges_from([[0, 1], [1, 2], [0, 3]])
    new_graph = NetworkX.intersection(g, h)
    expect(new_graph.nodes).to eq({0 => {}, 1 => {}, 2 => {}, 3 => {}})
    expect(new_graph.number_of_nodes).to be 4
    expect(new_graph.number_of_edges).to be 2
    expect(new_graph.adj).to eq({
                                  0 => {1 => {0 => {}}},
                                  1 => {2 => {0 => {}}},
                                  2 => {},
                                  3 => {}
                                })
  end

  it 'difference for Graph' do
    g = NetworkX::Graph.new
    h = NetworkX::Graph.new
    g.add_edges_from([[0, 1], [0, 2], [1, 2], [1, 3]])
    h.add_edges_from([[0, 1], [1, 2], [0, 3]])
    new_graph = NetworkX.difference(g, h)
    expect(new_graph.nodes).to eq({0 => {}, 1 => {}, 2 => {}, 3 => {}})
    expect(new_graph.number_of_nodes).to be 4
    expect(new_graph.number_of_edges).to be 2
    expect(new_graph.adj).to eq({
                                  0 => {2 => {}},
                                  1 => {3 => {}},
                                  2 => {0 => {}},
                                  3 => {1 => {}}
                                })
  end

  it 'difference for DiGraph' do
    g = NetworkX::DiGraph.new
    h = NetworkX::DiGraph.new
    g.add_edges_from([[0, 1], [0, 2], [1, 2], [1, 3]])
    h.add_edges_from([[0, 1], [1, 2], [0, 3]])
    new_graph = NetworkX.difference(g, h)
    expect(new_graph.nodes).to eq({0 => {}, 1 => {}, 2 => {}, 3 => {}})
    expect(new_graph.number_of_nodes).to be 4
    expect(new_graph.number_of_edges).to be 2
    expect(new_graph.adj).to eq({
                                  0 => {2 => {}},
                                  1 => {3 => {}},
                                  2 => {},
                                  3 => {}
                                })
  end

  it 'difference for MultiGraph' do
    g = NetworkX::MultiGraph.new
    h = NetworkX::MultiGraph.new
    g.add_edges_from([[0, 1], [0, 2], [1, 2], [1, 3]])
    h.add_edges_from([[0, 1], [1, 2], [0, 3]])

    new_graph = NetworkX.difference(g, h)
    expect(new_graph.nodes).to eq({0 => {}, 1 => {}, 2 => {}, 3 => {}})
    expect(new_graph.number_of_nodes).to be 4
    expect(new_graph.number_of_edges).to be 2
    expect(new_graph.adj).to eq({
                                  0 => {2 => {0 => {}}},
                                  1 => {3 => {0 => {}}},
                                  2 => {0 => {0 => {}}},
                                  3 => {1 => {0 => {}}}
                                })
  end

  it 'difference for MultiDiGraph' do
    g = NetworkX::MultiDiGraph.new
    h = NetworkX::MultiDiGraph.new
    g.add_edges_from([[0, 1], [0, 2], [1, 2], [1, 3]])
    h.add_edges_from([[0, 1], [1, 2], [0, 3]])
    new_graph = NetworkX.difference(g, h)
    expect(new_graph.nodes).to eq({0 => {}, 1 => {}, 2 => {}, 3 => {}})
    expect(new_graph.number_of_nodes).to be 4
    expect(new_graph.number_of_edges).to be 2
    expect(new_graph.adj).to eq({0 => {2 => {0 => {}}}, 1 => {3 => {0 => {}}}, 2 => {}, 3 => {}})
  end

  it 'symmetric_difference for Graph' do
    g = NetworkX::Graph.new
    h = NetworkX::Graph.new
    g.add_edges_from([[0, 1], [0, 2], [1, 2], [1, 3]])
    h.add_edges_from([[0, 1], [1, 2], [0, 3]])
    new_graph = NetworkX.symmetric_difference(g, h)
    expect(new_graph.nodes).to eq({0 => {}, 1 => {}, 2 => {}, 3 => {}})
    expect(new_graph.number_of_nodes).to be 4
    expect(new_graph.number_of_edges).to be 3
    expect(new_graph.adj).to eq({
                                  0 => {2 => {}, 3 => {}},
                                  1 => {3 => {}},
                                  2 => {0 => {}},
                                  3 => {1 => {}, 0 => {}}
                                })
  end

  it 'symmetric_difference for DiGraph' do
    g = NetworkX::DiGraph.new
    h = NetworkX::DiGraph.new
    g.add_edges_from([[0, 1], [0, 2], [1, 2], [1, 3]])
    h.add_edges_from([[0, 1], [1, 2], [0, 3]])
    new_graph = NetworkX.symmetric_difference(g, h)
    expect(new_graph.number_of_nodes).to be 4
    expect(new_graph.number_of_edges).to be 3
    expect(new_graph.nodes).to eq({0 => {}, 1 => {}, 2 => {}, 3 => {}})
    expect(new_graph.adj).to eq({0 => {2 => {}, 3 => {}}, 1 => {3 => {}}, 2 => {}, 3 => {}})
  end

  it 'symmetric_difference for MultiGraph' do
    g = NetworkX::MultiGraph.new
    h = NetworkX::MultiGraph.new
    g.add_edges_from([[0, 1], [0, 2], [1, 2], [1, 3]])
    h.add_edges_from([[0, 1], [1, 2], [0, 3]])

    new_graph = NetworkX.symmetric_difference(g, h)
    expect(new_graph.nodes).to eq({0 => {}, 1 => {}, 2 => {}, 3 => {}})
    expect(new_graph.number_of_nodes).to be 4
    expect(new_graph.number_of_edges).to be 3
    expect(new_graph.adj).to eq({
                                  0 => {2 => {0 => {}}, 3 => {0 => {}}},
                                  1 => {3 => {0 => {}}},
                                  2 => {0 => {0 => {}}},
                                  3 => {1 => {0 => {}}, 0 => {0 => {}}}
                                })
  end

  it 'symmetric_difference for MultiDiGraph' do
    g = NetworkX::MultiDiGraph.new
    h = NetworkX::MultiDiGraph.new
    g.add_edges_from([[0, 1], [0, 2], [1, 2], [1, 3]])
    h.add_edges_from([[0, 1], [1, 2], [0, 3]])

    new_graph = NetworkX.symmetric_difference(g, h)
    expect(new_graph.nodes).to eq({0 => {}, 1 => {}, 2 => {}, 3 => {}})
    expect(new_graph.number_of_nodes).to be 4
    expect(new_graph.number_of_edges).to be 3
    expect(new_graph.adj).to eq({
                                  0 => {2 => {0 => {}}, 3 => {0 => {}}},
                                  1 => {3 => {0 => {}}},
                                  2 => {},
                                  3 => {}
                                })
  end

  context 'when difference is called' do
    subject { NetworkX.difference(graph1, graph2) }

    before do
      graph2.clear
      graph2.add_node(1)
      graph2.add_node(2)
    end

    its('adj') { is_expected.to eq(1 => {2 => {}}, 2 => {1 => {}}) }
  end

  context 'when intersection is called' do
    subject { NetworkX.intersection(graph1, graph1) }

    its('adj') { is_expected.to eq(1 => {2 => {}}, 2 => {1 => {}}) }
  end
end
