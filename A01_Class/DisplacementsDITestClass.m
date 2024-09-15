classdef DisplacementsDITestClass < handle

    properties (Access = public)
        comparingMethodsMessage
        comparingValuesMessage
    end

    properties (Access = private)
        tolerance
    end

    properties (Access = private)
        uOriginal
        uDirectTest
        uIterativeTest
    end
    
    methods (Access = public)

        function obj = DisplacementsDITestClass(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.compareMethods();
            obj.compareValues();
            result = [obj.comparingMethodsMessage, newline, obj.comparingValuesMessage];
            disp(result);
        end

    end


    methods (Access = private)

        function init(obj,cParams)
            obj.saveInput(cParams);
            obj.loadOriginalU();
            obj.tolerance = 1e-6;
        end

        function saveInput(obj,cParams)
            obj.uIterativeTest = cParams.uIterative;
            obj.uDirectTest    = cParams.uDirect;
        end

        function loadOriginalU(obj)
            load("datas.mat","u");
            obj.uOriginal = u;
        end

        function compareMethods(obj)
            try
                assert(all(abs(obj.uDirectTest - obj.uIterativeTest) < obj.tolerance, 'all'), 'The displacements using whether a Direct or an Iterative solver are not the same.');
                obj.comparingMethodsMessage = 'The displacements using whether a Direct or an Iterative solver are the same.';
            catch ME
                obj.comparingMethodsMessage = ME.message;
            end
        end

        function compareValues(obj)
            try
                assert(all(abs(obj.uOriginal - obj.uIterativeTest) < obj.tolerance, 'all'), 'The displacements do not have the expected value using a Direct and an Iterative solver.');
                obj.comparingValuesMessage = 'The displacements have the expected value using a Direct and an Iterative solver.';
            catch ME
                obj.comparingValuesMessage = ME.message;
            end
        end

    end
    
end