classdef GlobalForceTestComputer < handle

    properties (Access = public)
        message
    end
    
    properties (Access = private)
        tolerance
    end

    properties (Access = private)
        fOriginal
        fTest
    end
    
    methods (Access = public)

        function obj = GlobalForceTestComputer(cParams)
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
            obj.loadOriginalF();
            obj.tolerance = 1e-6;
        end

        function saveInput(obj,cParams)
            obj.fTest = cParams.f;
        end

        function loadOriginalF(obj)
            load("datas.mat","f");
            obj.fOriginal = f;
        end

        function compareValues(obj)
            try
                assert(all(abs(obj.fOriginal - obj.fTest) < obj.tolerance, 'all'),'The global force does not coincide with the expected value');
                obj.message = 'The global force coincides with the expected value.';
            catch ME
                obj.message = ME.message;
            end
        end
    end
    
end



