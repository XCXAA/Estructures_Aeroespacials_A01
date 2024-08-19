classdef StressFunctionClass < handle

    properties (Access = private)
        R
        uElem
        sig
    end

    properties (Access = private)
        NumDOFNode
        NumElem
        NumNodesBar
        x
        m
        u
        Tm
        Tn
        Td
    end
    
    methods (Access = public)

        function sig = ComputeStress(obj, data, x, m, Tm, Tn, Td, u)
            obj.Init(data, x, m, Tm, Tn, Td, u);
            obj.CalculateSigma();
            sig = obj.sig;

        end

    end


    methods (Access = private)

        function Init(obj, data, x, m, Tm, Tn, Td, u)
            obj.NumDOFNode = data.NumDOFNode;
            obj.NumElem = data.NumElem;
            obj.NumNodesBar = data.NumNodesBar;
            obj.x = x;
            obj.m = m;
            obj.Tm = Tm;
            obj.Tn = Tn;
            obj.Td = Td;
            obj.u = u;
            obj.R = zeros(2,2*obj.NumDOFNode);
            obj.sig = zeros(obj.NumElem,1);
        end

        function sigma = CalculateSigmaPerBar(obj,e)
            aux = obj.Tn(e,:);
            node1 = obj.x(aux(1),:);
            node2 = obj.x(aux(2),:);
            l = 0; 
            for iNumDOFNode = 1:obj.NumDOFNode
                l = l + (node2(iNumDOFNode) - node1(iNumDOFNode))^2;
                obj.R(1,iNumDOFNode) = node2(iNumDOFNode) - node1(iNumDOFNode);
                obj.R(2,iNumDOFNode + obj.NumDOFNode) = node2(iNumDOFNode) - node1(iNumDOFNode); 
            end
            l = sqrt(l);
            obj.R = (1/l)*obj.R;
            LocalPos=(1/l)*obj.R*obj.uElem;
            sigma = obj.m(obj.Tm(e),1)*(LocalPos(2)-LocalPos(1)) + obj.m(obj.Tm(e),3);

        end

        function CalculateSigma(obj)
            for iNumElem = 1:obj.NumElem

                obj.uElem = zeros(obj.NumNodesBar*obj.NumDOFNode,1);
         
                for j = 1:obj.NumNodesBar*obj.NumDOFNode
        
                    obj.uElem(j) = obj.u(obj.Td(iNumElem,j));
                   
                end
        
                obj.sig(iNumElem) = obj.CalculateSigmaPerBar(iNumElem);
        
            end 

        end


    end
    
end