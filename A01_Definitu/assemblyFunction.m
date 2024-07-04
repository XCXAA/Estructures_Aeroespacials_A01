function [K,f] = assemblyFunction(data,Td,Kel,fel)
    K = zeros(data.ni*data.nnod,data.ni*data.nnod);
    f = zeros(data.ni*data.nnod,1);
    for e=1:data.nel
       
        for i = 1:2*data.ni
            f(Td(e,i),1)=f(Td(e,i),1)+fel(i,e);
             
            for j =1:2*data.ni
                
                K(Td(e,i),Td(e,j))=K(Td(e,i),Td(e,j))+Kel(i,j,e);
            end
        end
    end
end