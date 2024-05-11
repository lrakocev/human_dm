function[newTable] = getTable(myDir)
myFiles = dir(fullfile(myDir,'*.mat')); %gets all .mat files in struct
A = [];
B = [];
C = [];
D = [];
newTable= table(A,B,C,D);
for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    %     fprintf(1, 'Now reading %s\n', fullFileName);
%     disp(fullFileName)
    load(fullFileName)
    try
        C = {fitobject3.a,fitobject3.b,fitobject3.c,baseFileName};
        T = cell2table(C,'VariableNames',{'A','B','C', 'D'});
%         display([fitobject3.a,fitobject3.b,fitobject3.c,baseFileName])
    catch
        %         display(ME)
        %         display("Makes it here")
        try
            C = {1,fitobject2.b, fitobject2.c,baseFileName};
            T = cell2table(C,'VariableNames',{'A','B','C','D'});
%             display([fitobject2.a,fitobject2.b, 1, baseFileName])
        catch
            try
                C = {fitobject4.a,fitobject4.b,fitobject4.c, baseFileName};
                T = cell2table(C,'VariableNames',{'A','B', 'C', 'D'});
%                 display([fitobject4.a,fitobject4.b,fitobject4.c, baseFileName])
            catch
                disp("None Of them worked for some reason")
            end
        end
    end
    newTable = [newTable;T];
    clear fitobject3 fitobject2 fitobject 4
end
end