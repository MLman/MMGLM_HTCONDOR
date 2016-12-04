function t = comparearray(a,b)
    tmp = a-b;
    idx = find(a-b ~= 0,1,'first');
    if isempty(idx)
        t = 0;
    else
        t = tmp(idx);

    end
end
