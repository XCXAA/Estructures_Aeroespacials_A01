classdef SolveSystemClass < handle

    properties (Access = public)
        u
        r
    end

    properties (Access = private)
        vf
        params
    end

    properties (Access = private)
        totalNumDOF
        K
        solvertype
        f
        up
        vp
    end
    
    methods (Access = public)

        function obj = SolveSystemClass(cParams)
            obj.init(cParams); 
        end

        function computeSolution(obj)
            obj.calculateLHSRHS();
            obj.solveU();
            obj.solveR();
        end

    end


    methods (Access = private)

         function init(obj,cParams)
            obj.saveInputs(cParams)
            obj.createVfU();
        end

        function saveInputs(obj,cParams)
            obj.totalNumDOF = cParams.data.totalNumDOF;
            obj.K           = cParams.K;
            obj.f           = cParams.f;
            obj.solvertype  = cParams.solvertype;
            obj.vp          = cParams.vp;
            obj.up          = cParams.up;
        end

        function createVfU(obj)
            obj.vf = setdiff((1:obj.totalNumDOF)',obj.vp);
            obj.u = zeros(obj.totalNumDOF,1);
            obj.u(obj.vp) = obj.up;
        end

        function calculateLHSRHS(obj)
            LHS = obj.K(obj.vf, obj.vf);
            RHS = obj.f(obj.vf) - [obj.K(obj.vf, obj.vp)]*obj.u(obj.vp);
            obj.params.LHS = LHS;
            obj.params.RHS = RHS;
        end

        function solveU(obj)
            solver = Solver.createSolver(obj.solvertype,obj.params);
            obj.u(obj.vf) = solver.computeSolution();   
        end

        function solveR(obj)
            obj.r = [obj.K(obj.vp, :)]*obj.u - obj.f(obj.vp);  
        end

    end
    
end