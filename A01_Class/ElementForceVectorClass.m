classdef ElementForceVectorClass < handle

    properties (Access = public)
       fElem
    end
    
    properties (Access = private)
        K
        R
        node1
        node2
        l
    end

    properties (Access = private)
        numDOFNode
        numNodes      
        numElem
        Tn
        Tm
        x
        m
    end
    
    methods (Access = public)

        function obj = ElementForceVectorClass(cParams)
            obj.init(cParams);
        end

        function computeElementForceVector(obj)
            for iNumElem = 1:obj.numElem
                obj.definefElemPerElem(iNumElem);
            end
        end

    end


    methods (Access = private)

        function init(obj,cParams)
            obj.saveInputs(cParams)
            obj.createMatrix();
        end

        function saveInputs(obj,cParams)
            obj.numDOFNode   = cParams.data.numDOFNode;
            obj.numElem      = cParams.data.numElem;
            obj.x            = cParams.x;
            obj.Tm           = cParams.Tm;
            obj.Tn           = cParams.Tn;
            obj.m            = cParams.m;
        end

        function createMatrix(obj)
            obj.fElem  = zeros(2*obj.numDOFNode, obj.numElem);
            obj.K      = zeros(2,1);
            obj.R      = zeros(2,2*obj.numDOFNode);
        end

        function initializeK(obj,iNumElem)
            obj.K(1,1)  = -1;
            obj.K(2,1)  =  1;
            TnRow       =  obj.Tn(iNumElem,:);
            obj.node1   =  obj.x(TnRow(1),:);
            obj.node2   =  obj.x(TnRow(2),:);
            obj.l       =  0;
        end

        function calculateLK(obj,iNumElem)
            for jNumDofNode = 1:obj.numDOFNode
                obj.l                               = obj.l + (obj.node2(jNumDofNode) - obj.node1(jNumDofNode))^2;
                obj.R(1,jNumDofNode)                = obj.node2(jNumDofNode) - obj.node1(jNumDofNode);
                obj.R(2,jNumDofNode+obj.numDOFNode) = obj.node2(jNumDofNode) - obj.node1(jNumDofNode);
            end
                obj.l  = sqrt(obj.l);
                obj.R  = (1/obj.l)*obj.R;
                obj.K  = (obj.m(obj.Tm(iNumElem),2)*obj.m(obj.Tm(iNumElem),3)/obj.l)*obj.K;
        end

        function definefElemPerElem(obj,iNumElem)
            if obj.m(obj.Tm(iNumElem),3) ~= 0
                obj.initializeK(iNumElem);
                obj.calculateLK(iNumElem);
                RInvert               = obj.R';
                obj.fElem(:,iNumElem) = RInvert*obj.K;
            end
        end

    end
    
end