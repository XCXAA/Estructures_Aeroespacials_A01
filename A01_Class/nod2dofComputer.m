classdef nod2dofComputer < handle

    methods (Access = public, Static)

        function I = returnI(numDOFNode,node,DOF)    
                I = numDOFNode*node + DOF - numDOFNode;
        end
    end

end

    

