classdef IterativeSolver < Solver

    properties (Access = private)
        Solution
    end

    
    methods (Access = public)

        function uL = computeSolution(obj, LHS, RHS)
            obj.SolveEquationIteratively(LHS, RHS);
            uL = obj.Solution;
        end

    end

    
    methods (Access = private)

        function SolveEquationIteratively(obj, LHS, RHS)
            obj.Solution = pcg(LHS,RHS,1e-6,100);
        end

    end
    
end
