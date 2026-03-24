function nnmf_table = fit_nnmf(approach_data)
    
nnmf_table = [];
for i = 1:length(approach_data)
    results = approach_data(i);
    results = results{1};
    if ~isempty(results)

        mat = zeros(4,4);
        for r = 1:4
          for c = 1:4
              val  = mean(results(results.cost == c & results.rew == r, :).approach_rate);
              if isempty(val)
                  val = NaN;
              end
              mat(r,c) = val;
          end
        end

         mat = fillmissing(mat,'linear');%fill in any missing values with the mean of the rest
         mat = mat/100;

       
        subid = results.subjectidnumber(1);
        story_num = results.story_num(1); 
        story_type = results.story_type(1);

        try
            [w, h] = nnmf(mat, 1);
        catch
            continue
        end

        row.subjectidnumber = subid;
        row.story_num = story_num;
        row.experiment = story_type;
        
        row.w = w';
        row.h = h;

        nnmf_table = [nnmf_table; row];
    end 
end

end