function str = timestamp()
%TIMESTAMP prints out the string of timestamp.
%
%   Ex : 20150529_140221
%   
%   See Also: CLOCK

%   $ Hyunwoo J. Kim $  $ 2015/05/29 14:02:21 (CDT) $

t = clock;
str = sprintf('%d%d%d_%d%d%02d\n',t(1),t(2),t(3),t(4),t(5),round(t(6)));
end