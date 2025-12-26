excel_limit = 100000;
file_name = "sigmoids_by_5s_excel_file";
row_count = 0;
doc_num = 1;

x = [1 2 3 4];

all_combos = combinations(1:5:100, 1:5:100, 1:5:100, 1:5:100);

for j = 1:height(all_combos)
    row = [];
    combo = all_combos(j,:);
    lvl1 = combo.Var1;
    lvl2 = combo.Var2; 
    lvl3 = combo.Var3;
    lvl4 = combo.Var4;
    y = [lvl1 lvl2 lvl3 lvl4];
    
    counter = 0;
    [func, gof_sig] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
    while counter < 20 && gof_sig.rsquare < .7
        [func, gof_sig] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
        counter = counter+1;
    end 
    
    row.lvl1 = lvl1;
    row.lvl2 = lvl2;
    row.lvl3 = lvl3;
    row.lvl4 = lvl4;
    row.a = func.a;
    row.b = func.b;
    row.c = func.c;
    row.rsq = gof_sig.rsquare;
    
    row = struct2table(row, 'AsArray',1);

    try
        writetable(row, file_name + string(doc_num) + '.xlsx', 'WriteMode', 'append');
    catch
        doc_num = doc_num + 1;
        writetable(row, file_name + string(doc_num) + '.xlsx', 'WriteMode', 'append');
    end    
end
