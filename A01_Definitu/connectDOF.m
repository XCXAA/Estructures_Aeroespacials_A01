function Td = connectDOF(data,Tn)
Td = zeros(data.nel,2*data.ni);
aux = data.ni;
for i = 1:data.nel
    for j = 1:data.nne
        
        aux=data.ni-1;
        Td(i,data.ni*j)=data.ni*Tn(i,j);
        for c= 0:aux
        Td(i,data.ni*j-1*c)=data.ni*Tn(i,j)-1*c;
        
        end
    
    end
end