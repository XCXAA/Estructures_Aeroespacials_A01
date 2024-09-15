classdef IterativeSolver < Solver

    properties (Access = private)
        solution
    end

    properties (Access = private)
        LHS
        RHS
    end

    methods (Access = public)

        function obj = IterativeSolver(cParams)
            obj.init(cParams)
        end

        function uL = computeSolution(obj)
            obj.solveEquationIteratively();
            uL = obj.solution;
        end

    end
    
    methods (Access = private)

        function init(obj,cParams)
            obj.LHS = cParams.LHS;
            obj.RHS = cParams.RHS;
        end

        function solveEquationIteratively(obj)
            obj.solution = pcg(obj.LHS,obj.RHS,1e-6,100);
        end

    end
    
end
