%unfoldstruct is a script to copy all fields in a struct.
%mystrucut is the input of the function.

if ~isempty(who('mystruct'))
        fprintf(2,'%s is overwritten.\n','mystruct');
end
if ~isempty(who('sfields'))
        fprintf(2,'%s is overwritten.\n','sfields');
end

sfields = fieldnames(mystruct);
for i = 1:length(sfields)
    if ~isempty(who(sfields{i}))
        fprintf(2,'%s is overwritten.\n',sfields{i});
    end
    eval(sprintf('%s = mystruct.%s;',sfields{i}, sfields{i}));
end