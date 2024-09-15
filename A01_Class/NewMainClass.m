classdef NewMainClass < handle

    properties (Access = public)
        outputs
    end

    properties (Access = private)
        KElem
        K
        fElem
        f
        up
        vp
        u
        r
        sig
    end

    properties (Access = private)
        inputs
    end
    

    methods (Access = public)

        function obj = NewMainClass(cParams)
            obj.init(cParams); 
        end

        function compute(obj)
            obj.solve();
            obj.saveOutputs();
        end
    end

    methods (Access = private)

        function init(obj,cParams)
            obj.saveInputs(cParams)
            obj.initializeData();
            obj.createTd();
        end

        function saveInputs(obj,cParams)
            obj.inputs   = cParams;
        end

        function initializeData(obj)
            dataObject = DataClass(obj.inputs);
            obj.inputs.data = dataObject;
        end

        function createTd(obj)
            TdClass = connectDOFClass(obj.inputs);
            TdClass.compute();
            obj.inputs.Td = TdClass.Td;
        end

        function computeElementStiffnessMatrix(obj)
            KElemClass = ElementStiffnessMatrixClass(obj.inputs);
            KElemClass.computeElementStiffnessMatrix;
            obj.KElem = KElemClass.KElem;
            obj.inputs.KElem = obj.KElem;
        end

        function assemblyGlobalStiffnessMatrix(obj)
            KClass = StiffnessMatrixClass(obj.inputs);
            KClass.assemblyGlobalStiffnessMatrix();
            obj.K = KClass.KGlobal;
            obj.inputs.K = obj.K;
        end

        function computeElementForceVector(obj)
            fElemClass = ElementForceVectorClass(obj.inputs);
            fElemClass.computeElementForceVector();
            obj.fElem = fElemClass.fElem;
            obj.inputs.fElem = obj.fElem;
        end

        function computeForceVector(obj)
            fClass = ForceVectorClass(obj.inputs);
            fClass.computeForceVector();
            obj.f = fClass.f;
            obj.inputs.f = obj.f;
        end

        function applyBC(obj)
            UpVpClass = ApplyBC(obj.inputs);
            UpVpClass.compute();
            obj.up = UpVpClass.up;
            obj.vp = UpVpClass.vp;
            obj.inputs.up = obj.up;
            obj.inputs.vp = obj.vp;
        end

        function solveSystem(obj)
            UVClass = SolveSystemClass(obj.inputs);
            UVClass.computeSolution();
            obj.u = UVClass.u;
            obj.r = UVClass.r;
            obj.inputs.u = obj.u;
        end

        function calculateStress(obj)
            SigClass = StressFunctionClass(obj.inputs);
            SigClass.computeStress();
            obj.sig = SigClass.sig;
        end

        function solve(obj)
            obj.computeElementStiffnessMatrix();
            obj.assemblyGlobalStiffnessMatrix();
            obj.computeElementForceVector();
            obj.computeForceVector();
            obj.applyBC();
            obj.solveSystem();
            obj.calculateStress();
        end

        function saveOutputs(obj)
            obj.outputs.KElem = obj.KElem;
            obj.outputs.K     = obj.K;
            obj.outputs.fElem = obj.fElem;
            obj.outputs.f     = obj.f;
            obj.outputs.up    = obj.up;
            obj.outputs.vp    = obj.vp;
            obj.outputs.u     = obj.u;
            obj.outputs.r     = obj.r;
            obj.outputs.sig   = obj.sig;
        end

    end
    
end