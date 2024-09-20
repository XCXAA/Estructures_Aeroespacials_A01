classdef ElementStiffnessMatrixComputer < handle

   properties (Access = public)
        KElem
   end

   properties (Access = private)
        KLocal
        R
        node1
        node2
        l
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
    end
    
    methods (Access = public)

        function obj = ElementStiffnessMatrixComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeElementStiffnessMatrix();
        end

    end


    methods (Access = private)

        function init(obj,cParams)
            obj.saveInputs(cParams);
            obj.createKR();
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
        end

        function createKR(obj)
            obj.KElem    =  zeros(2*obj.numDOFNode,2*obj.numDOFNode,obj.numElem);
            obj.KLocal   =  zeros(2,2);
            obj.R        =  zeros(2,2*obj.numDOFNode);
        end

        function initializeKLocal(obj,iNumElem)
            obj.KLocal(1,1)    =  1;
            obj.KLocal(1,2)    = -1;
            obj.KLocal(2,1)    = -1;
            obj.KLocal(2,2)    =  1;
            TnRow              =  obj.Tn(iNumElem,:);
            obj.node1          =  obj.x(TnRow(1),:);
            obj.node2          =  obj.x(TnRow(2),:);
            obj.l              =  0;
        end

        function intializeLR(obj)
            for jNumDOFNode = 1:obj.numDOFNode
                obj.l                                 =  obj.l + (obj.node2(jNumDOFNode) - obj.node1(jNumDOFNode))^2;
                obj.R(1,jNumDOFNode)                  =  obj.node2(jNumDOFNode) - obj.node1(jNumDOFNode);
                obj.R(2,jNumDOFNode+obj.numDOFNode)   =  obj.node2(jNumDOFNode)- obj.node1(jNumDOFNode);
            end
            obj.l = sqrt(obj.l);
            obj.R = (1/obj.l)*obj.R;
        end
        
        function computeElementStiffnessMatrix(obj)
            for iNumElem =1:obj.numElem
            obj.initializeKLocal(iNumElem);
            obj.intializeLR();
            RInvert                 =  obj.R';
            obj.KLocal              =  (obj.m(obj.Tm(iNumElem),1)*obj.m(obj.Tm(iNumElem),2)/obj.l)*obj.KLocal;
            obj.KElem(:,:,iNumElem) =  RInvert*obj.KLocal*obj.R;
            end
        end


    end


end
    
