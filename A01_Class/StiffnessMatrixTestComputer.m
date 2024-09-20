classdef StiffnessMatrixTestComputer < handle

    properties (Access = public)
        message
    end

    properties (Access = private)
        tolerance
    end

    properties (Access = private)
        KOriginal
        KTest
    end
    
    methods (Access = public)

        function obj = StiffnessMatrixTestComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.compareValues();
            disp(obj.message);
        end

    end


    methods (Access = private)

        function init(obj,cParams)
            obj.saveInput(cParams);
            obj.loadOriginalK();
            obj.tolerance = 1e-6;
        end

        function saveInput(obj,cParams)
            obj.KTest = cParams.K;
        end

        function loadOriginalK(obj)
            load("datas.mat","K");
            obj.KOriginal = K;
        end

        function compareValues(obj)
            try
                assert(all(abs(obj.KOriginal - obj.KTest) < obj.tolerance, 'all'),'The globla stiffness matrix has not been assembled properly');
                obj.message = 'The global stiffness matrix has been assembled properly.';
            catch ME
                obj.message = ME.message;
            end
        end
    end
    
end