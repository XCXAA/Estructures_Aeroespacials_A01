function [u,r] = solveSystem(data,K,f,up,vp,solvertype)

    vf = setdiff((1:data.ndof)',vp);
    u = zeros(data.ndof,1);
    u(vp) =up;

    if solvertype == '0'
        %Original solver of uL
        u(vf) = [K(vf,vf)]^-1*(f(vf)-[K(vf,vp)]*u(vp));

    else
        %New solver with Solver class
        LHS = K(vf,vf);
        RHS = f(vf)-[K(vf,vp)]*u(vp);
        solver = Solver.createSolver(solvertype);
        u(vf) = solver.computeSolution(LHS, RHS);
    
        r=[K(vp,:)]*u-f(vp);

    end

end