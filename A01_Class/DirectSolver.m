classdef DirectSolver < Solver

    properties (Access = private)
        Solution
    end

    
    methods (Access = public)

        function uL = computeSolution(obj, LHS, RHS)
            obj.SolveEquationDirectly(LHS, RHS);
            uL = obj.Solution;
        end

    end


    methods (Access = private)

        function SolveEquationDirectly(obj, LHS, RHS)
            obj.Solution = LHS\RHS;
        end

    end
    
end
