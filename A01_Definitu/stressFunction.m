function sig = stressFunction(data,x,Tn,m,Tm,Td,u)

    sig=zeros(data.nel,1);
    
    for e=1:data.nel

        u_el=zeros(data.nne*data.ni,1);
 
        for i=1:data.nne*data.ni

            u_el(i)=u(Td(e,i));
           
        end

        sig(e) = sigma_e(x, Tn, m, e, Tm, u_el, data);

    end 


