classdef GlobalForceVectorComputer < handle

    properties (Access = public)
        f
    end

    properties (Access = private)
        numDOFNode
        numNodes      
        numElem
        F
        Td
        n
        fElem
    end
    
    methods (Access = public)

        function obj = GlobalForceVectorComputer(cParams)
            obj.init(cParams); 
        end

        function compute(obj)
            obj.computeGlobalForceVector();
        end

    end


    methods (Access = private)

        function init(obj,cParams)
            obj.saveInputs(cParams)
            obj.createfn();
        end

        function saveInputs(obj,cParams)
            obj.numDOFNode   = cParams.data.numDOFNode;
            obj.numElem      = cParams.data.numElem;
            obj.numNodes     = cParams.data.numNodes;
            obj.fElem        = cParams.fElem;
            obj.F            = cParams.F;
            obj.Td           = cParams.Td;
        end

        function createfn(obj)
            obj.f  = zeros(obj.numDOFNode*obj.numNodes,1);
            obj.n  = size(obj.F,1);
        end

        function calculateInitialf(obj)
            for iNumElem = 1:obj.numElem
                for iNumDOFNode = 1:2*obj.numDOFNode
                    obj.f(obj.Td(iNumElem,iNumDOFNode),1) = obj.f(obj.Td(iNumElem,iNumDOFNode),1)+ obj.fElem(iNumDOFNode,iNumElem);
                end
            end
        end

        function setPointLoad(obj)
            for in = 1:obj.n
                I        = nod2dofComputer.returnI(obj.numDOFNode,obj.F(in,1),obj.F(in,2));
                obj.f(I) = obj.F(in,3);
            end 
        end

        function computeGlobalForceVector(obj)
           obj.calculateInitialf();
           obj.setPointLoad();
        end

    end
    
end