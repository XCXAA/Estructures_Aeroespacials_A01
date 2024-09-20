classdef ProblemComputer < handle

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

        function obj = ProblemComputer(cParams)
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
            dataObject = DataComputer(obj.inputs);
            obj.inputs.data = dataObject;
        end

        function createTd(obj)
            TdObject = DOFConnectivitiesComputer(obj.inputs);
            TdObject.compute();
            obj.inputs.Td = TdObject.Td;
        end

        function computeElementStiffnessMatrix(obj)
            KElemObject = ElementStiffnessMatrixComputer(obj.inputs);
            KElemObject.compute();
            obj.KElem = KElemObject.KElem;
            obj.inputs.KElem = obj.KElem;
        end

        function assemblyGlobalStiffnessMatrix(obj)
            KObject = GlobalStiffnessMatrixComputer(obj.inputs);
            KObject.compute();
            obj.K = KObject.KGlobal;
            obj.inputs.K = obj.K;
        end

        function computeElementForceVector(obj)
            fElemObject = ElementForceVectorComputer(obj.inputs);
            fElemObject.compute();
            obj.fElem = fElemObject.fElem;
            obj.inputs.fElem = obj.fElem;
        end

        function computeGlobalForceVector(obj)
            fObject = GlobalForceVectorComputer(obj.inputs);
            fObject.compute();
            obj.f = fObject.f;
            obj.inputs.f = obj.f;
        end

        function applyBC(obj)
            UpVpObject = BCApplier(obj.inputs);
            UpVpObject.compute();
            obj.up = UpVpObject.up;
            obj.vp = UpVpObject.vp;
            obj.inputs.up = obj.up;
            obj.inputs.vp = obj.vp;
        end

        function solveSystem(obj)
            UVObject = SystemSolver(obj.inputs);
            UVObject.compute();
            obj.u = UVObject.u;
            obj.r = UVObject.r;
            obj.inputs.u = obj.u;
        end

        function calculateStress(obj)
            SigObject = StressComputer(obj.inputs);
            SigObject.compute();
            obj.sig = SigObject.sig;
        end

        function solve(obj)
            obj.computeElementStiffnessMatrix();
            obj.assemblyGlobalStiffnessMatrix();
            obj.computeElementForceVector();
            obj.computeGlobalForceVector();
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