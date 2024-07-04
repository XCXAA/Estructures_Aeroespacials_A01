function [u,r] = solveSystem(data,K,f,up,vp)

    vf=setdiff((1:data.ndof)',vp);
    u=zeros(data.ndof,1);
    u(vp)=up;
    u(vf)=[K(vf,vf)]^-1*(f(vf)-[K(vf,vp)]*u(vp));
    r=[K(vp,:)]*u-f(vp);

end