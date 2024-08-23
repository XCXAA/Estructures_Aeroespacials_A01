classdef DataClass < handle

    properties (Access = private)
        x
        Tn
    end

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
            obj.InputData(ni,x,Tn);
            obj.NodalCoordinatesInit();
            obj.NodalConnectivitiesInit();
        end

    end


    methods (Access = private)

        function InputData(obj,ni,x,Tn)
            obj.NumDOFNode = ni;
            obj.x = x;
            obj.Tn = Tn;
        end

        function NodalCoordinatesInit(obj)
            obj.NumNodes = size(obj.x,1); % Number of nodes 
            obj.NumDim = size(obj.x,2);   % Problem dimension
            obj.TotalNumDOF = obj.NumNodes*obj.NumDOFNode;  % Total number of degrees of freedom
        end

        function NodalConnectivitiesInit(obj)
            obj.NumElem = size(obj.Tn,1); % Number of elements 
            obj.NumNodesBar = size(obj.Tn,2); % Number of nodes in a bar
        end

    end
    
end