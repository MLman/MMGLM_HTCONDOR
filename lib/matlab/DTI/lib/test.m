% Test Code

p = rand(3);
p = p*p';
v = rand(3);
v = (v +v')/2;
%p = eye(3);
%v = p;
D = expmap_spd(p,v);
v = logmap_spd(p,D);
vnew = embeddingR6(p,v);
innerprod_TpM_spd(v,v,p)
vnew'*vnew


recoveredv = invembeddingR6(p,vnew)