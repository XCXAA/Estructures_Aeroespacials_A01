classdef ApplyBC < handle

    properties (Access = public)
        up
        vp
    end

    properties (Access = private)
        numRowsp
    end

    properties (Access = private)
        numDOFNode
        p
    end
    
    methods (Access = public)

        function obj = ApplyBC(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.applyBC();
        end

    end


    methods (Access = private)

        function init(obj,cParams)
            obj.saveInputs(cParams)
            obj.createUpVp();
        end

        function saveInputs(obj,cParams)
            obj.numDOFNode = cParams.data.numDOFNode;
            obj.p          = cParams.p;
            obj.numRowsp   = size(obj.p,1);
        end

        function createUpVp(obj)
            obj.up = zeros(obj.numRowsp,1);
            obj.vp = zeros(obj.numRowsp,1);
        end

        function applyBC(obj)
             for iNumRowsp = 1:obj.numRowsp
                obj.vp(iNumRowsp) = nod2dofClass.returnI(obj.numDOFNode,obj.p(iNumRowsp,1),obj.p(iNumRowsp,2));
                obj.up(iNumRowsp) = obj.p(iNumRowsp,3);
            end 
        end
        
    end
    
end