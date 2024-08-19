classdef nod2dofClass < handle

    methods (Access = public, Static)

        function I = ReturnI(NumDOFNode,Node,DOF)
            
                I = NumDOFNode*Node + DOF - NumDOFNode;

        end
    end

end

    

