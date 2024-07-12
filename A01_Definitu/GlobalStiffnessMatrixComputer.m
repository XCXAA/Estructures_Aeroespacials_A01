classdef GlobalStiffnessMatrixComputer < handle

    properties (Access = private)
        Kglobal
        numel
    end

    
    methods (Access = public)

        function K = computeGlobalStiffnessMatrix(obj, numni, numnnod, Tnod, Kelem)
            obj.init(numni, numnnod, Tnod);
            obj.assemblyGlobalStiffnessMatrix(numni, Tnod, Kelem);
            K = obj.Kglobal;
        end

    end


    methods (Access = private)

        function init(obj, numni, numnnod, Tnod)
            obj.Kglobal = zeros(numni * numnnod, numni * numnnod);
            obj.numel = size(Tnod, 1);
        end

        function assemblyGlobalStiffnessMatrix(obj, numni, Tnod, Kelem)
            for e = 1:obj.numel
                for i = 1:2*numni
                    for j = 1:2*numni
                        obj.Kglobal(Tnod(e, i), Tnod(e, j)) = obj.Kglobal(Tnod(e, i), Tnod(e, j)) + Kelem(i, j, e);
                    end
                end
            end
        end

    end
    
end
