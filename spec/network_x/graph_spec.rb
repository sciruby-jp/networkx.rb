RSpec.describe NetworkX::Graph do
  subject { graph }

  let(:graph) { described_class.new(name: 'Cities', type: 'undirected') }

  before do
    graph.add_nodes(%w[Nagpur Mumbai])
    graph.add_edge('Nagpur', 'Mumbai')
    graph.add_edges([%w[Nagpur Chennai], %w[Chennai Bangalore]])
    graph.add_node('Kolkata')
  end

  context 'when graph has been assigned attributes' do
    its('graph') { is_expected.to eq(name: 'Cities', type: 'undirected') }
  end

  context 'when a new node/s has/have been created' do
    its('nodes') do
      is_expected.to eq('Kolkata' => {},
                        'Nagpur' => {},
                        'Mumbai' => {},
                        'Chennai' => {},
                        'Bangalore' => {})
    end
  end

  context 'when a new edge/s has/have been added' do
    its('adj') do
      is_expected.to eq('Nagpur' => {'Mumbai' => {}, 'Chennai' => {}},
                        'Bangalore' => {'Chennai' => {}},
                        'Chennai' => {'Nagpur' => {}, 'Bangalore' => {}},
                        'Mumbai' => {'Nagpur' => {}}, 'Kolkata' => {})
    end
  end

  it 'nodes' do
    graph = NetworkX::Graph.new
    graph.add_edges([[:x, :y], [:y, :z]])
    expect(graph.nodes(data: false).sort).to eq([:x, :y, :z])
    expect(graph.nodes(data: true)).to eq({x: {}, y: {}, z: {}})
  end

  it 'each_node' do
    graph = NetworkX::Graph.new
    graph.add_edges([[:x, :y], [:y, :z]])
    expect(graph.each_node.to_a).to eq([:x, :y, :z])
    expect(graph.each_node(data: true).to_a).to eq([[:x, {}], [:y, {}], [:z, {}]])
  end

  it 'add_path' do
    graph = NetworkX::Graph.new
    graph.add_path(%i[a b c])
    expect(graph.number_of_nodes).to be 3
    expect(graph.number_of_edges).to be 2
    expect(graph.edges).to eq [[:a, :b] , [:b, :c]]
  end

  context 'when node/s is/are removed' do
    before do
      graph.remove_node('Nagpur')
      graph.remove_nodes(%w[Chennai Mumbai])
    end

    its('nodes') { is_expected.to eq('Kolkata' => {}, 'Bangalore' => {}) }
    its('adj') { is_expected.to eq('Kolkata' => {}, 'Bangalore' => {}) }
  end

  context 'when edge/s is/are removed' do
    before do
      graph.remove_edge('Nagpur', 'Mumbai')
      graph.remove_edges([%w[Nagpur Chennai], %w[Chennai Bangalore]])
    end

    its('adj') do
      is_expected.to eq('Kolkata' => {}, 'Bangalore' => {}, \
                        'Nagpur' => {}, 'Chennai' => {}, 'Mumbai' => {})
    end
  end

  context 'when weighted edge/s is/are added' do
    before do
      graph.add_weighted_edge('Nagpur', 'Mumbai', 15)
      graph.add_weighted_edges([%w[Nagpur Kolkata]], [10])
    end

    its('adj') do
      is_expected.to eq('Bangalore' => {'Chennai' => {}},
                        'Chennai' => {'Nagpur' => {}, 'Bangalore' => {}},
                        'Kolkata' => {'Nagpur' => {weight: 10}},
                        'Mumbai' => {'Nagpur' => {weight: 15}},
                        'Nagpur' => {'Mumbai' => {weight: 15}, 'Chennai' => {}, 'Kolkata' => {weight: 10}})
    end
  end

  context 'when number of edges are calculated' do
    its('number_of_edges') do
      is_expected.to eq 3
    end
  end

  it 'test number_of_edges of empty graph returns 0' do
    empty_graph = NetworkX::Graph.new
    expect(empty_graph.number_of_edges).to be 0
  end

  it 'when size is called' do
    graph.add_weighted_edge('Nagpur', 'Mumbai', 15)
    expect(graph.size).to be 3
    expect(graph.size(true)).to eq 15
  end

  context 'when subgraph is called' do
    subject { graph.subgraph(%w[Nagpur Mumbai]) }

    its('nodes') do
      is_expected.to eq('Nagpur' => {}, 'Mumbai' => {})
    end

    its('adj') do
      is_expected.to eq('Nagpur' => {'Mumbai' => {}}, 'Mumbai' => {'Nagpur' => {}})
    end
  end

  context 'when edges_subgraph is called' do
    subject { graph.edge_subgraph([%w[Nagpur Mumbai], %w[Nagpur Chennai]]) }

    its('nodes') do
      is_expected.to eq('Nagpur' => {}, 'Mumbai' => {}, 'Chennai' => {})
    end

    its('adj') do
      is_expected.to eq('Nagpur' => {'Chennai' => {}, 'Mumbai' => {}}, \
                        'Mumbai' => {'Nagpur' => {}}, 'Chennai' => {'Nagpur' => {}})
    end
  end

  it 'test `subgraph` method' do
    g = NetworkX::Graph.new
    g.add_nodes_from(0...4)
    g.add_edges([[0, 1], [1, 2], [1, 3]])

    h = g.subgraph([0, 1, 2])

    expect(h.nodes(data: false)).to eq [0, 1, 2]
    expect(h.edges).to eq [[0, 1], [1, 2]]
  end

  it 'test errors' do
    g = NetworkX::Graph.new
    expect { g.add_edges('abc') }.to raise_error(ArgumentError)
    expect { g.add_nodes(nil) }.to raise_error(ArgumentError)
    expect { g.remove_nodes('wwww') }.to raise_error(ArgumentError)
    expect { g.remove_edges('css') }.to raise_error(ArgumentError)
    expect { g.get_edge_data('yes', 'no') }.to raise_error(KeyError, 'No such edge exists!')
    expect { g.subgraph('xxx') }.to raise_error(ArgumentError)
    expect { g.edge_subgraph('xxx') }.to raise_error(ArgumentError)
  end

  it 'test get_node_data' do
    g = NetworkX::Graph.new
    g.add_node('Tokyo', country: 'Japan')
    expect(g.get_node_data('Tokyo')).to eq({country: 'Japan'})
  end

  it 'test get_edge_data' do
    g = NetworkX::Graph.new
    g.add_edge('New York', 'Tokyo', time_diff: 14)
    expect(g.get_edge_data('New York', 'Tokyo')).to eq({time_diff: 14})
  end

  # [EXPERIMENTAL]
  it 'test `add_edges_from`' do
    g = NetworkX::Graph.new
    g.add_nodes_from(0...10)
    g.add_edges_from([[0, 1], [1, 2], [3, 2], [5, 3], [6, 9], [7, 1]])
    expect(g.number_of_nodes).to be 10
    expect(g.number_of_edges).to be 6
  end

  it 'test add_nodes(Range)' do
    g = NetworkX::Graph.new
    g.add_nodes(0...10)
    expect(g.number_of_nodes).to be 10
  end

  # test experimental methods: `add_nodes_from`
  it 'test add_nodes_from(String)' do
    g = NetworkX::Graph.new
    g.add_nodes_from('Hello')
    expect(g.number_of_nodes).to be 4
    expect(g.node?('l')).to be true
    expect(g.node?('h')).to be false
    expect(g.node?('o')).to be true
    expect(g.node?('x')).to be false
  end

  it 'test degree' do
    graph = NetworkX::Graph.new
    graph.add_edges([[0, 1], [1, 2], [2, 3]])
    expect(graph.degree[0]).to be 1
    expect(graph.degree[1]).to be 2
    expect(graph.degree[2]).to be 2
    expect(graph.degree[3]).to be 1

    expect(graph.degree([1, 3, 2])).to eq({1 => 2, 3 => 1, 2 => 2})
  end

  # test experimental methods: `add_nodes_from`, `add_weighted_edges_from`, `each_edge`, `edges`
  # https://atcoder.jp/contests/abc051/tasks/abc051_d
  it 'ABC051 D: example 1' do
    n, _m = 3, 3
    edges = [[1, 2, 1], [1, 3, 1], [2, 3, 3]]

    g = NetworkX::Graph.new
    g.add_nodes_from(1..n)
    g.add_weighted_edges_from(edges)

    expect(g.number_of_nodes).to be 3
    expect(g.number_of_edges).to be 3
    expect(g.adj[1][2][:weight]).to be 1
    expect(g.adj[3][1][:weight]).to be 1
    expect(g.adj[2][3][:weight]).to be 3

    expect(g.edges).to eq [[1, 2], [1, 3], [2, 3]]

    fw = NetworkX.floyd_warshall(g)
    expect(fw[1][2]).to be 1
    expect(fw[1][3]).to be 1
    expect(fw[2][1]).to be 1
    expect(fw[2][3]).to be 2
    expect(fw[3][1]).to be 1
    expect(fw[3][2]).to be 2
  end

  # test experimental methods: `add_nodes_from`, `add_weighted_edges_from`, `each_edge`, `edges`
  # https://atcoder.jp/contests/abc051/tasks/abc051_d
  it 'ABC051 D: example 2' do
    n, _m = 3, 2
    edges = [[1, 2, 1], [2, 3, 1]]

    g = NetworkX::Graph.new
    g.add_nodes_from(1..n)
    g.add_weighted_edges_from(edges)

    expect(g.number_of_nodes).to be 3
    expect(g.number_of_edges).to be 2
    expect(g.adj[1][2][:weight]).to be 1
    expect(g.adj[3][2][:weight]).to be 1

    expect(g.edges).to eq [[1, 2], [2, 3]]
    expect(g.edges(data: true)).to eq [[1, 2, {weight: 1}], [2, 3, {weight: 1}]]

    fw = NetworkX.floyd_warshall(g)
    expect(fw[1][2]).to be 1
    expect(fw[1][3]).to be 2
    expect(fw[2][1]).to be 1
    expect(fw[2][3]).to be 1
    expect(fw[3][1]).to be 2
    expect(fw[3][2]).to be 1
  end

  it 'test info method' do
    output = <<~'OUTPUT'
      Type: NetworkX::Graph
      Number of nodes: 0
      Number of edges: 0
    OUTPUT
    graph = NetworkX::Graph.new
    expect(graph.info).to eq(output)
  end
end
