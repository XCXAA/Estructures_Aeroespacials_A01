classdef DOFConnectivitiesComputer < handle

    properties (Access = public)
        Td
    end

    properties (Access = private)
        numDOFNode
        numElem
        numNodesBar
        aux
        Tn
    end
    
    methods (Access = public)

        function obj = DOFConnectivitiesComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeDOFConnectivitiesMatrix();
        end

    end


    methods (Access = private)

        function init(obj,cParams)
            obj.saveInputs(cParams)
            obj.createTd();
        end

        function saveInputs(obj,cParams)
            obj.numDOFNode   = cParams.data.numDOFNode;
            obj.numElem      = cParams.data.numElem;
            obj.numNodesBar  = cParams.data.numNodesBar;
            obj.aux          = cParams.data.numDOFNode;
            obj.Tn           = cParams.Tn; 
        end

        function createTd(obj)
            obj.Td = zeros(obj.numElem,2*obj.numDOFNode);
        end

        function defineRestRowValues(obj,iNumElem,jNumNodesBar)
            for iAux = 0:obj.aux
                obj.Td(iNumElem,obj.numDOFNode*jNumNodesBar-iAux) = obj.numDOFNode*obj.Tn(iNumElem,jNumNodesBar)- iAux;
            end
        end

        function computeAllRowValues(obj,iNumElem)
            for jNumNodesBar = 1:obj.numNodesBar
                obj.aux                                      = obj.numDOFNode - 1;
                obj.Td(iNumElem,obj.numDOFNode*jNumNodesBar) = obj.numDOFNode*obj.Tn(iNumElem,jNumNodesBar);
                obj.defineRestRowValues(iNumElem,jNumNodesBar);
            end
        end
        function computeDOFConnectivitiesMatrix(obj)
            for iNumElem = 1:obj.numElem
                obj.computeAllRowValues(iNumElem);        
            end
        end

    end

end