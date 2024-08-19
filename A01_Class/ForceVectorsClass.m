classdef ForceVectorsClass < handle

    properties (Access = private)
        felem
        f
        K
        R
    end

    properties (Access = private)
        NumDOFNode
        NumNodes      
        NumElem
        Tn
        Tm
        x
        F
        n
        m
        Td
    end
    
    methods (Access = public)

        function [fel,f] = CreateForceVectors(obj, data, x, Tm, Tn, F, m, Td)
            obj.Init(data, x, Tm, Tn, F, m, Td);
            obj.ComputeElementForceVector();
            obj.ComputeTotalForceVector();
            fel = obj.felem;
            f = obj.f;
        
        end

    end


    methods (Access = private)

        function Init(obj, data, x, Tm, Tn, F, m, Td)
            obj.NumDOFNode = data.NumDOFNode;
            obj.NumElem = data.NumElem;
            obj.NumNodes = data.NumNodes;
            obj.felem = zeros(2*obj.NumDOFNode, obj.NumElem);
            obj.f = zeros(obj.NumDOFNode*obj.NumNodes,1);
            obj.K = zeros(2,1);
            obj.R = zeros(2,2*obj.NumDOFNode);
            obj.x = x;
            obj.Tm = Tm;
            obj.Tn = Tn;
            obj.F = F;
            obj.n = size(F,1);
            obj.m = m;
            obj.Td = Td;
        end

        function ComputeElementForceVector(obj)
             for iNumElem = 1:obj.NumElem
                if obj.m(obj.Tm(iNumElem),3) ~= 0
                    obj.K(1,1)=-1;
                    obj.K(2,1)=1;
                    Aux = obj.Tn(iNumElem,:);
                    node1 = obj.x(Aux(1),:);
                    node2 = obj.x(Aux(2),:);
                    l = 0;
                    for jNumDofNode = 1:obj.NumDOFNode
                        l= l + (node2(jNumDofNode)-node1(jNumDofNode))^2;
                        obj.R(1,jNumDofNode)=node2(jNumDofNode)-node1(jNumDofNode);
                        obj.R(2,jNumDofNode+obj.NumDOFNode)=node2(jNumDofNode)-node1(jNumDofNode);
                    end
                    l = sqrt(l);
                    obj.R = (1/l)*obj.R;
                    RInvert = obj.R';
                    obj.K= (obj.m(obj.Tm(iNumElem),2)*obj.m(obj.Tm(iNumElem),3)/l)*obj.K;
                    obj.felem(:,iNumElem)=RInvert*obj.K;
                end
            end
            
        end

        function ComputeTotalForceVector(obj)
            for iNumElem = 1:obj.NumElem
       
                for iNumDOFNode = 1:2*obj.NumDOFNode

                    obj.f(obj.Td(iNumElem,iNumDOFNode),1) = obj.f(obj.Td(iNumElem,iNumDOFNode),1)+ obj.felem(iNumDOFNode,iNumElem);
                     
                end
            end

            for in = 1:obj.n

                I = nod2dofClass.ReturnI(obj.NumDOFNode,obj.F(in,1),obj.F(in,2));
                obj.f(I) = obj.F(in,3);
            
            end 
            
        end

    end
    
end