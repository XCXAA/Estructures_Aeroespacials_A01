classdef DataClass < handle

    properties (Access = public)
        NumDOFNode
        NumNodes
        NumDim
        TotalNumDOF
        NumElem
        NumNodesBar
    end
    
    methods (Access = public)

        function Init(obj, ni, x, Tn)
            obj.InputData(ni);
            obj.NodalCoordinatesInit(x);
            obj.NodalConnectivitiesInit(Tn);
        end

    end


    methods (Access = private)

        function InputData(obj,ni)
            obj.NumDOFNode = ni;
        end

        function NodalCoordinatesInit(obj,x)
            obj.NumNodes = size(x,1); % Number of nodes 
            obj.NumDim = size(x,2);   % Problem dimension
            obj.TotalNumDOF = obj.NumNodes*obj.NumDOFNode;  % Total number of degrees of freedom
        end

        function NodalConnectivitiesInit(obj,Tn)
            obj.NumElem = size(Tn,1); % Number of elements 
            obj.NumNodesBar = size(Tn,2); % Number of nodes in a bar
        end

    end
    
end