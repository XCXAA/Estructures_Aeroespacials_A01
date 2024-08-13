classdef GlobalStiffnessMatrixComputer < handle

    %Coses calculades
    properties (Access = private)
        Kglobal
 
    end

    %Entrades
    properties (Access = private)
       
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
            % guardar les cosess
        end

        function assemblyGlobalStiffnessMatrix(obj, numni, Tnod, Kelem)
            for iElem = 1:obj.numel
                for iNode = 1:2*numni
                    for jNode = 1:2*numni
                        obj.Kglobal(Tnod(iElem, iNode), Tnod(iElem, jNode)) = obj.Kglobal(Tnod(iElem, iNode), Tnod(iElem, jNode)) + Kelem(iNode, jNode, iElem);
                    end
                end
            end
        end

    end
    
end
