function single_table = consolidate_metadata(results, all_ids)

all_ids = unique(string(all_ids));
results = results(ismember(results.subjectidnumber,all_ids), :);

single_table = [];
for i = 1:length(all_ids)
    id = all_ids(i);
    id_table = results(results.subjectidnumber == id, :);
    first_row = id_table(1,:);
    single_table = [single_table; first_row];
end

end