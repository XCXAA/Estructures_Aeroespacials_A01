function [sig_0]=prestress_calculation(sig_p,Kel,data,x,Tn,m,Tm,Td,F,p,sig_c,e,sf)

if any(sig_c./sig_p(:) > -sf) && any(sig_c./sig_p(:) < 0)

sf_min=0;

while sf_min<sf
   
    % 2.1.2 Compute element force vectors
    fel = forceFunction(data,x,Tn,m,Tm);
    
    % 2.2 Assemble global stiffness matrix
    [K,f] = assemblyFunction(data,Td,Kel,fel);  
 
    % 2.3.1 Apply prescribed DOFs
    [up,vp] = applyBC(data,p);
    
    % 2.3.2 Apply point loads
    f = pointLoads(data,Td,f,F);
    
    % 2.4 Solve system
    [u,r] = solveSystem(data,K,f,up,vp);
    
    % 2.5 Compute stress
    sig = stressFunction(data,x,Tn,m,Tm,Td,u);
    
    sig_min=min(sig);

    sf_min=sig_c/abs(sig_min);
    
    m(e,3)=m(e,3)+0.01;
    
end

sig_0=m(e,3);

scale = 100; % Set a number to visualize deformed structure properly
units = 'MPa'; % Define in which units you're providing the stress vector


plot2DBars(data,x,Tn,u,sig,scale,units);

else

sig_0=0;

end
end 