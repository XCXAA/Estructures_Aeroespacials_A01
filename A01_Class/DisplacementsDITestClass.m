classdef DisplacementsDITestClass < handle

    properties (Access = private)
        ComparingMethodsMessage
        ComparingValuesMessage
        tolerance
    end

    properties (Access = private)
        u_original
        u_direct_test
        u_iterative_test
    end
    
    methods (Access = public)

        function Result = testResult(obj, u_Direct,u_Iterative)
            obj.init(u_Direct,u_Iterative);
            obj.CompareMethods();
            obj.CompareValues();
            Result = [obj.ComparingMethodsMessage, newline, obj.ComparingValuesMessage];
        end

    end


    methods (Access = private)

        function init(obj,u_Direct,u_Iterative)
            load("datas.mat","u");
            obj.u_original = u;
            obj.u_iterative_test = u_Iterative;
            obj.u_direct_test = u_Direct;
            obj.tolerance = 1e-6;
        end

        function CompareMethods(obj)
            try
                assert(all(abs(obj.u_direct_test - obj.u_iterative_test) < obj.tolerance, 'all'), 'The displacements using whether a Direct or an Iterative solver are not the same.');
                obj.ComparingMethodsMessage = 'The displacements using whether a Direct or an Iterative solver are the same.';
            catch ME
                obj.ComparingMethodsMessage = ME.message;
            end
        end

        function CompareValues(obj)
            try
                assert(all(abs(obj.u_original - obj.u_iterative_test) < obj.tolerance, 'all'), 'The displacements do not have the expected value using a Direct and an Iterative solver.');
                obj.ComparingValuesMessage = 'The displacements have the expected value using a Direct and an Iterative solver.';
            catch ME
                obj.ComparingValuesMessage = ME.message;
            end
        end

    end
    
end