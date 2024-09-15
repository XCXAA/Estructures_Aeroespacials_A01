classdef Solver < handle

    methods (Access = public, Static)

        function solver = createSolver(solvertype,cParams)
            switch solvertype
                case 'Direct'
                    solver = DirectSolver(cParams);
                case 'Iterative'
                    solver = IterativeSolver(cParams);
                otherwise
                    error('Unknown solver type');
            end
        end

    end

    
end
