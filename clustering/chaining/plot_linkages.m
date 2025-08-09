function plot_linkages(summary_table,row_num,sort_type,save_to)

% replace w/ dist_from_mean
if sort_type == "desc"
    summary_table = summary_table( ~isnan(summary_table.dist_from_mean),:);
end
sorted_by_std_devs =  sortrows(summary_table,"dist_from_mean",sort_type);
top_row = sorted_by_std_devs(row_num,:);
prob = top_row.sample_mean;

t1 = top_row.t1;
c1 = top_row.c1;

all_connections = summary_table(summary_table.t1 == t1 & summary_table.c1 == c1, :);

figure 
create_graph(all_connections)
set(gcf,'renderer','Painters')
savefig(save_to + "/validate_chain_links_" + sort_type + ".fig")

end

function create_graph(all_connections)

start_name = all_connections.t1 + " " + all_connections.c1;
all_connections.node_names = all_connections.t2 + " " + all_connections.c2;
num_cnx = height(all_connections);
start_node = ones(1, num_cnx);
end_node = 2:num_cnx+1;
weights = [all_connections.sample_mean];
names = all_connections.node_names;
all_nodes = unique([start_name names], 'stable');
G = digraph(start_node, end_node, weights, all_nodes);


plot(G, 'EdgeLabel', weights, 'LineWidth', weights*10, 'EdgeCData',weights)


end