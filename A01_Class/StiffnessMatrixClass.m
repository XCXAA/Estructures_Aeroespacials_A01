classdef StiffnessMatrixClass < handle

   properties (Access = public)
       KGlobal
   end

   properties (Access = private)
        numNodes
        numDOFNode
        numElem
        Td
        x
        Tn
        m
        Tm
        KElem
    end
    
    methods (Access = public)

        function obj = StiffnessMatrixClass(cParams)
            obj.init(cParams);
        end

        function assemblyGlobalStiffnessMatrix(obj)
            for iElem = 1:obj.numElem
                obj.setKGlobalValuesPerElem(iElem);
            end
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.saveInputs(cParams);
            obj.createKGlobal();
        end

        function saveInputs(obj,cParams)
            obj.numNodes    =  cParams.data.numNodes;
            obj.numDOFNode  =  cParams.data.numDOFNode;
            obj.numElem     =  cParams.data.numElem;
            obj.Td          =  cParams.Td;
            obj.x           =  cParams.x;
            obj.Tn          =  cParams.Tn;
            obj.m           =  cParams.m;
            obj.Tm          =  cParams.Tm;
            obj.KElem       =  cParams.KElem;
        end

        function createKGlobal(obj)
            obj.KGlobal = zeros(obj.numDOFNode * obj.numNodes, obj.numDOFNode * obj.numNodes);
        end

        function setKGlobalRowValues(obj,iElem,iNode)
            for jNode = 1:2*obj.numDOFNode
                obj.KGlobal(obj.Td(iElem, iNode), obj.Td(iElem, jNode)) = obj.KGlobal(obj.Td(iElem, iNode), obj.Td(iElem, jNode)) + obj.KElem(iNode, jNode, iElem);
            end
        end
        
        function setKGlobalValuesPerElem(obj,iElem)
            for iNode = 1:2*obj.numDOFNode
                obj.setKGlobalRowValues(iElem,iNode);
            end
        end
    end


end
    
