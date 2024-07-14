function [u,r] = solveSystem(data,K,f,up,vp)

    vf = setdiff((1:data.ndof)',vp);
    u = zeros(data.ndof,1);
    u(vp) =up;

    %Original solver of uL
    %u(vf) = [K(vf,vf)]^-1*(f(vf)-[K(vf,vp)]*u(vp));

    %New solver with Solver class
    LHS = K(vf,vf);
    RHS = f(vf)-[K(vf,vp)]*u(vp);
    solvertype = "Direct";
    solver = Solver.createSolver(solvertype);
    u(vf) = solver.computeSolution(LHS, RHS);

    r=[K(vp,:)]*u-f(vp);

end