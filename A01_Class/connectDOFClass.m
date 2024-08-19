classdef connectDOFClass < handle

    properties (Access = private)
        Td
    end

    properties (Access = private)
        NumDOFNode
        NumElem
        NumNodesBar
        Aux
        Tn
    end
    
    methods (Access = public)

        function Result = CreateTd(obj, data, Tn)
            obj.init(data,Tn);
            obj.ComputeTd();
            Result = obj.Td;
        end

    end


    methods (Access = private)

        function init(obj,data, Tn)
            obj.NumDOFNode = data.NumDOFNode;
            obj.NumElem = data.NumElem;
            obj.NumNodesBar = data.NumNodesBar;
            obj.Aux = data.NumDOFNode;
            obj.Td = zeros(data.NumElem,2*data.NumDOFNode);
            obj.Tn = Tn;
        end

        function ComputeTd(obj)
            for iNumElem = 1:obj.NumElem

                for jNumNodesBar = 1:obj.NumNodesBar

                    obj.Aux = obj.NumDOFNode - 1;
                    obj.Td(iNumElem,obj.NumDOFNode*jNumNodesBar) = obj.NumDOFNode*obj.Tn(iNumElem,jNumNodesBar);

                    for iAux= 0:obj.Aux

                        obj.Td(iNumElem,obj.NumDOFNode*jNumNodesBar-iAux) = obj.NumDOFNode*obj.Tn(iNumElem,jNumNodesBar)- iAux;
                    end

                end
                    
            end

        end
    
    end


end