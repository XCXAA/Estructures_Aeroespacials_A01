function fel = forceFunction(data,x,Tn,m,Tm)
    fel = zeros(2*data.ni, data.nel);
    K = zeros(2,1);
    R = zeros(2,2*data.ni);
    for i = 1:data.nel
        if m(Tm(i),3) ~= 0
            K(1,1)=-1;
            K(2,1)=1;
            aux = Tn(i,:);
            node1 = x(aux(1),:);
            node2 = x(aux(2),:);
            l = 0;
            for j = 1:data.ni
                l= l + (node2(j)-node1(j))^2;
                R(1,j)=node2(j)-node1(j);
                R(2,j+data.ni)=node2(j)-node1(j);
            end
            l = sqrt(l);
            R = (1/l)*R;
            R_trans = R';
            K= (m(Tm(j),2)*m(Tm(j),3)/l)*K;
            fel(:,i)=R_trans*K;
        end
    end
end