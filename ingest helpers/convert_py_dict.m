function [M,revM] = convert_py_dict(dict)

M = dictionary;
revM = dictionary;
for raw_key = py.list(keys(dict))
    key = raw_key{1};
    value = dict{key};
    M(string(key)) = double(value);
    revM(double(value)) = string(key);
end

end
