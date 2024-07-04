function sigma = sigma_e(x, Tn, m, e, Tm, u_el, data)
    R = zeros(2,2*data.ni); 
    aux = Tn(e,:);
    node1 = x(aux(1),:);
    node2 = x(aux(2),:);
    l = 0; 
    for i = 1:data.ni
        l = l + (node2(i)-node1(i))^2;
        R(1,i)=node2(i)-node1(i);
        R(2,i+data.ni)=node2(i)-node1(i); 
    end
    l = sqrt(l);
    R = (1/l)*R;
    pos_local=(1/l)*R*u_el;
    sigma = m(Tm(e),1)*(pos_local(2)-pos_local(1))+m(Tm(e),3);
end