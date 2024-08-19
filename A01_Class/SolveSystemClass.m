classdef SolveSystemClass < handle

    properties (Access = private)
        u
        r
        up
        vp
        vf
        NumRowsp
    end

    properties (Access = private)
        NumDOFNode
        TotalNumDOF
        p
        K
        solvertype
        f
    end
    
    methods (Access = public)

        function [u,r] = ComputeSolution(obj, data, p, K, f, solvertype)
            obj.Init(data, p, K, f, solvertype);
            obj.applyBC();
            obj.InitBeforeSolveSystem();
            obj.Solver();
            u = obj.u;
            r = obj.r;
            
        end

    end


    methods (Access = private)

        function Init(obj, data, p, K, f, solvertype)
            obj.NumDOFNode = data.NumDOFNode;
            obj.TotalNumDOF = data.TotalNumDOF;
            obj.p = p;
            obj.NumRowsp = size(obj.p,1);
            obj.up = zeros(obj.NumRowsp,1);
            obj.vp = zeros(obj.NumRowsp,1);
            obj.K = K;
            obj.f = f;
            obj.solvertype = solvertype;
        end

        function applyBC(obj)

             for iNumRowsp = 1:obj.NumRowsp

                obj.vp(iNumRowsp)=nod2dofClass.ReturnI(obj.NumDOFNode,obj.p(iNumRowsp,1),obj.p(iNumRowsp,2));
                obj.up(iNumRowsp)=obj.p(iNumRowsp,3);
            
            end 
        end

        function InitBeforeSolveSystem(obj)
            
            obj.vf = setdiff((1:obj.TotalNumDOF)',obj.vp);
            obj.u = zeros(obj.TotalNumDOF,1);
            obj.u(obj.vp) = obj.up;

        end

        function Solver(obj)
            LHS = obj.K(obj.vf, obj.vf);
            RHS = obj.f(obj.vf) - [obj.K(obj.vf, obj.vp)]*obj.u(obj.vp);
            solver = Solver.createSolver(obj.solvertype);
            obj.u(obj.vf) = solver.computeSolution(LHS, RHS);
        
            obj.r = [obj.K(obj.vp, :)]*obj.u - obj.f(obj.vp);
            
        end

    end
    
end