classdef StiffnessMatrixClass < handle

   properties (Access = private)
        KGlobal
        KElem
        KLocal
        R
    end

    properties (Access = private)
        NumNodes
        NumDOFNode
        NumElem
        Td
        x
        Tn
        m
        Tm
    end
    
    methods (Access = public)

        function [Kel,K] = computeStiffnessMatrix(obj, data, Td, x, Tn, m, Tm)
            obj.init(data, Td, x, Tn, m, Tm);
            obj.computeElementStiffnessMatrix();
            obj.assemblyGlobalStiffnessMatrix();
            Kel = obj.KElem;
            K = obj.KGlobal;
        end

    end


    methods (Access = private)

        function init(obj, data, Td, x, Tn, m, Tm)

            obj.NumNodes = data.NumNodes;
            obj.NumDOFNode = data.NumDOFNode;
            obj.NumElem = data.NumElem;
            obj.KGlobal = zeros(obj.NumDOFNode * obj.NumNodes, obj.NumDOFNode * obj.NumNodes);
            obj.Td = Td;
            obj.KElem = zeros(2*obj.NumDOFNode,2*obj.NumDOFNode,obj.NumElem);
            obj.KLocal = zeros(2,2);
            obj.R = zeros(2,2*obj.NumDOFNode);
            obj.x = x;
            obj.Tn = Tn;
            obj.m = m;
            obj.Tm = Tm;
        end

        function computeElementStiffnessMatrix(obj)
            for iNumElem =1:obj.NumElem

            obj.KLocal(1,1)=1;
            obj.KLocal(1,2)=-1;
            obj.KLocal(2,1)=-1;
            obj.KLocal(2,2)=1;
            Aux = obj.Tn(iNumElem,:);
            node1 = obj.x(Aux(1),:);
            node2 = obj.x(Aux(2),:);
            l = 0;

            for jNumDOFNode = 1:obj.NumDOFNode
                l= l + (node2(jNumDOFNode)-node1(jNumDOFNode))^2;
                obj.R(1,jNumDOFNode)=node2(jNumDOFNode)-node1(jNumDOFNode);
                obj.R(2,jNumDOFNode+obj.NumDOFNode)=node2(jNumDOFNode)-node1(jNumDOFNode);
            end

            l = sqrt(l);
            obj.R = (1/l)*obj.R;
            RInvert = obj.R';
            obj.KLocal = (obj.m(obj.Tm(iNumElem),1)*obj.m(obj.Tm(iNumElem),2)/l)*obj.KLocal;
            obj.KElem(:,:,iNumElem) = RInvert*obj.KLocal*obj.R;
            end
        end

        function assemblyGlobalStiffnessMatrix(obj)

            for iElem = 1:obj.NumElem
                for iNode = 1:2*obj.NumDOFNode
                    for jNode = 1:2*obj.NumDOFNode
                        obj.KGlobal(obj.Td(iElem, iNode), obj.Td(iElem, jNode)) = obj.KGlobal(obj.Td(iElem, iNode), obj.Td(iElem, jNode)) + obj.KElem(iNode, jNode, iElem);
                    end
                end
            end
        end
    end


end
    
