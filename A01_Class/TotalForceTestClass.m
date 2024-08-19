classdef TotalForceTestClass < handle

    properties (Access = private)
        Message
    end

    properties (Access = private)
        f_original
        f_test
    end
    
    methods (Access = public)

        function Result = testResult(obj, f_new)
            obj.init(f_new);
            obj.CompareValues();
            Result = obj.Message;
        end

    end


    methods (Access = private)

        function init(obj,f_new)
            load("datas.mat","f");
            obj.f_original = f;
            obj.f_test = f_new;
        end

        function CompareValues(obj)
            try
                assert(all(obj.f_original == obj.f_test, 'all'),'The total force does not coincide with the expected value');
                obj.Message = 'The total force coincides with the expected value.';
            catch ME
                obj.Message = ME.message;
            end
        end
    end
    
end