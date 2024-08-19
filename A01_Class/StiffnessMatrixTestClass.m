classdef StiffnessMatrixTestClass < handle

    properties (Access = private)
        Message
    end

    properties (Access = private)
        K_original
        K_test
    end
    
    methods (Access = public)

        function Result = testResult(obj, K_class)
            obj.init(K_class);
            obj.CompareValues();
            Result = obj.Message;
        end

    end


    methods (Access = private)

        function init(obj,K_class)
            load("datas.mat","K");
            obj.K_original = K;
            obj.K_test = K_class;
        end

        function CompareValues(obj)
            try
                assert(all(obj.K_original == obj.K_test, 'all'),'The stiffness matrix has not been assembled properly');
                obj.Message = 'The stiffness matrix has been assembled properly.';
            catch ME
                obj.Message = ME.message;
            end
        end
    end
    
end