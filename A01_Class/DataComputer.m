classdef DataComputer < handle

    properties (Access = public)
        numDOFNode
        numNodes
        numDim
        totalNumDOF
        numElem
        numNodesBar
    end
    
    methods (Access = public)

        function obj = DataComputer(cParams)
            obj.init(cParams);
        end

    end

    methods (Access = private)

        function init(obj, cParams)
            obj.numDOFNode = cParams.numDOFNodeWheel;
            obj.initializeNodalCoord(cParams);
            obj.initializeNodalConnectivities(cParams);
        end

        function initializeNodalCoord(obj,cParams)
            obj.numNodes     = size(cParams.x,1); 
            obj.numDim       = size(cParams.x,2);   
            obj.totalNumDOF  = obj.numNodes*obj.numDOFNode;  
        end

        function initializeNodalConnectivities(obj,cParams)
            obj.numElem       = size(cParams.Tn,1);
            obj.numNodesBar   = size(cParams.Tn,2);
        end

    end
    
end