classdef Solver < handle

    methods (Access = public, Static)

        function solver = createSolver(solvertype)
            switch solvertype
                case 'Direct'
                    solver = DirectSolver();
                case 'Iterative'
                    solver = IterativeSolver();
                otherwise
                    error('Unknown solver type');

            end
        end

    end

    
end
