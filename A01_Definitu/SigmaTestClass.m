classdef SigmaTestClass < handle

    properties (Access = private)
        Message
        tolerance
    end

    properties (Access = private)
        sig_original
        sig_test
    end
    
    methods (Access = public)

        function Result = testResult(obj, sig_test)
            obj.init(sig_test);
            obj.CompareValues();
            Result = obj.Message;
        end

    end


    methods (Access = private)

        function init(obj,sig_test)
            load("datas.mat","sig");
            obj.sig_original = sig;
            obj.sig_test = sig_test;
            obj.tolerance = 1e-6;
        end

        function CompareValues(obj)
            try
                assert(all(abs(obj.sig_original - obj.sig_test) < obj.tolerance, 'all'), 'The sigma does not coincide with the expected value.');
                obj.Message = 'The sigma coincides with the expected value.';
            catch ME
                obj.Message = ME.message;
            end
        end

    end
    
end