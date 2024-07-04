function Kel = stiffnessFunction(data,x,Tn,m,Tm)
    Kel=zeros(2*data.ni,2*data.ni,data.nel);
    K_local=zeros(2,2);
    R=zeros(2,2*data.ni);
    for i=1:data.nel
        K_local(1,1)=1;
        K_local(1,2)=-1;
        K_local(2,1)=-1;
        K_local(2,2)=1;
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
        K_local = (m(Tm(i),1)*m(Tm(i),2)/l)*K_local;
        Kel(:,:,i) = R_trans*K_local*R;
    end
end