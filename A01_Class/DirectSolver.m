classdef DirectSolver < Solver

    properties (Access = private)
        solution
    end

    properties (Access = private)
        LHS
        RHS
    end

    methods (Access = public)

        function obj = DirectSolver(cParams)
            obj.init(cParams);
        end

        function uL = compute(obj)
            obj.solveEquationDirectly();
            uL = obj.solution;
        end

    end


    methods (Access = private)

        function init(obj,cParams)
            obj.LHS = cParams.LHS;
            obj.RHS = cParams.RHS;
        end

        function solveEquationDirectly(obj)
            obj.solution = obj.LHS\obj.RHS;
        end

    end
    
end
