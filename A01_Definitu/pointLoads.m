function f = pointLoads(data,Td,f,F)

n=size(F,1);

for i=1:n

    I=nod2dof(data.ni,F(i,1),F(i,2));
    f(I)=F(i,3);

end 

end