classdef StressFunctionClass < handle

    properties (Access = public)
        sig
    end

    properties (Access = private)
        R
        uElem
        l
        node1
        node2
    end

    properties (Access = private)
        numDOFNode
        numElem
        numNodesBar
        x
        m
        u
        Tm
        Tn
        Td
    end
    
    methods (Access = public)

        function obj = StressFunctionClass(cParams)
            obj.init(cParams);
        end

        function computeStress(obj)
            obj.calculateSigma();
        end

    end


    methods (Access = private)

        function init(obj,cParams)
            obj.saveInputs(cParams)
            obj.createRSig();
        end

        function saveInputs(obj,cParams)
            obj.numDOFNode      = cParams.data.numDOFNode;
            obj.numElem         = cParams.data.numElem;
            obj.numNodesBar     = cParams.data.numNodesBar;
            obj.x               = cParams.x;
            obj.m               = cParams.m;
            obj.Tm              = cParams.Tm;
            obj.Tn              = cParams.Tn;
            obj.Td              = cParams.Td;
            obj.u               = cParams.u;
        end

        function createRSig(obj)
            obj.R       = zeros(2,2*obj.numDOFNode);
            obj.sig     = zeros(obj.numElem,1);
        end

        function setNodesL(obj,e)
            aux         = obj.Tn(e,:);
            obj.node1   = obj.x(aux(1),:);
            obj.node2   = obj.x(aux(2),:);
            obj.l       = 0;  
        end

        function calculateRL(obj)
            for iNumDOFNode = 1:obj.numDOFNode
                obj.l                                   = obj.l + (obj.node2(iNumDOFNode) - obj.node1(iNumDOFNode))^2;
                obj.R(1,iNumDOFNode)                    = obj.node2(iNumDOFNode) - obj.node1(iNumDOFNode);
                obj.R(2,iNumDOFNode + obj.numDOFNode)   = obj.node2(iNumDOFNode) - obj.node1(iNumDOFNode); 
            end
            obj.l = sqrt(obj.l);
            obj.R = (1/obj.l)*obj.R;
        end


        function sigmaPerBar = CalculateSigmaPerBar(obj,e)
            obj.setNodesL(e);
            obj.calculateRL();
            LocalPos    = (1/obj.l)*obj.R*obj.uElem;
            sigmaPerBar = obj.m(obj.Tm(e),1)*(LocalPos(2)-LocalPos(1)) + obj.m(obj.Tm(e),3);
        end

        function calculateUElem(obj,iNumElem)
            obj.uElem   = zeros(obj.numNodesBar*obj.numDOFNode,1); 
            for j = 1:obj.numNodesBar*obj.numDOFNode
                obj.uElem(j) = obj.u(obj.Td(iNumElem,j));
            end
        end

        function calculateSigma(obj)
            for iNumElem = 1:obj.numElem
                obj.calculateUElem(iNumElem);
                obj.sig(iNumElem) = obj.CalculateSigmaPerBar(iNumElem);
            end 
        end

    end
    
end