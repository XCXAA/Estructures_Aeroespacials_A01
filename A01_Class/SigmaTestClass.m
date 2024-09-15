classdef SigmaTestClass < handle

    properties (Access = public)
        message
    end

    properties (Access = private)
        sigOriginal
        sigTest
        tolerance
    end
    
    methods (Access = public)

        function obj = SigmaTestClass(cParams)
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
            obj.loadOriginalSig();
            obj.tolerance = 1e-6;
        end

        function saveInput(obj,cParams)
            obj.sigTest = cParams.sig;
        end

        function loadOriginalSig(obj)
            load("datas.mat","sig");
            obj.sigOriginal = sig;
        end

        function compareValues(obj)
            try
                assert(all(abs(obj.sigOriginal - obj.sigTest) < obj.tolerance, 'all'), 'The sigma does not coincide with the expected value.');
                obj.message = 'The sigma coincides with the expected value.';
            catch ME
                obj.message = ME.message;
            end
        end

    end
    
end