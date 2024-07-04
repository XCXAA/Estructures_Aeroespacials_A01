function [up,vp] = applyBC(data,p)

n_p=size(p,1);
up=zeros(n_p,1);
vp=zeros(n_p,1);

for i=1:n_p

    vp(i)=nod2dof(data.ni,p(i,1),p(i,2));
    up(i)=p(i,3);

end 
end