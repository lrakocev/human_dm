function [newTable,rs] = getTablePIG(myDir,is_big)
myFiles = dir(fullfile(myDir,'*.mat')); %gets all .mat files in struct
if is_big
    h = height(myFiles);
    rand_rows = randperm(h, 5000);
    myFiles = myFiles(rand_rows, :);
end
A = [];
B = [];
C = [];
D = [];
E = [];
newTable= table(A,B,C,D,E);
rs = [];
for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    %     fprintf(1, 'Now reading %s\n', fullFileName);
%     disp(fullFileName)
    load(fullFileName)
    try
        coeffs = mdl1.Coefficients.Estimate;
        R = mdl1.Rsquared.Ordinary;
        C = [coeffs; 0; string(baseFileName)];
        T = array2table(C','VariableNames',{'A','B','C', 'D','E'});
    catch     
        try
            coeffs = mdl2.Coefficients.Estimate;
            R = mdl2.Rsquared.Ordinary;
            C = [coeffs; string(baseFileName)];
            T = array2table(C','VariableNames',{'A','B','C', 'D','E'});
        catch
            try        
                coeffs = mdl3.Coefficients.Estimate;
                R = mdl3.Rsquared.Ordinary;
                C = [coeffs; string(baseFileName)];
                T = array2table(C','VariableNames',{'A','B','C', 'D','E'});
            catch
                continue
            end
        end
    end
    newTable = [newTable;T];
    rs = [rs; R];
    clear mdl1 mdl2 mdl3 
end
end