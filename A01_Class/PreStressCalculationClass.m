classdef PreStressCalculationClass < handle

    properties (Access = private)
        CriticalSigma
        PreStress
    end

    properties (Access = private) 
        m 
    end
    
    methods (Access = public)

        function Result = ComputeResult(obj, m, WheelRadius, data, SafetyFactor, MaterialIndex, sig, x, Tn, Tm, Td, F, p)
            obj.Init(m);
            obj.CriticalStressCalculation(WheelRadius);
            obj.PreStressCalculation(data, SafetyFactor, MaterialIndex, sig, x, Tn, Tm, Td, F, p)
            Result = obj.PreStress;
        end

    end


    methods (Access = private)

        function Init(obj, m)
            obj.m = m;
        end

        function CriticalStressCalculation(obj,WheelRadius)
            obj.CriticalSigma = (pi^2*obj.m(2,1).*obj.m(2,4))/(obj.m(2,2).*(WheelRadius*10^3)^2);
        end

        function PreStressCalculation(obj, data, SafetyFactor, MaterialIndex, sig, x, Tn, Tm, Td, F, p)

            if any(obj.CriticalSigma./sig(:) > - SafetyFactor) && any(obj.CriticalSigma./sig(:) < 0)
            
            MinimumSafetyFactor=0;
            
            while MinimumSafetyFactor < SafetyFactor
               
                % 2.1.1 Compute element stiffness matrices & Assemble global stiffness matrix
                StiffnessMatrix = StiffnessMatrixClass();
                [~,K] = StiffnessMatrix.computeStiffnessMatrix(data, Td, x, Tn, obj.m, Tm);
                
                % 2.1.2 Compute element and total force vectors
                FrameForceVectors = ForceVectorsClass();
                [~,f] = FrameForceVectors.CreateForceVectors(data, x, Tm, Tn, F, obj.m, Td);
                
                % 2.2 Solve system
                solvertype = "Direct";
                SolveSystem = SolveSystemClass();
                [u,~] = SolveSystem.ComputeSolution(data, p, K, f, solvertype);
                
                % 2.5 Compute stress
                StressFunction = StressFunctionClass();
                CalculatedSigma = StressFunction.ComputeStress(data, x, obj.m, Tm, Tn, Td, u);
                
                MinimumSig=min(CalculatedSigma);
            
                MinimumSafetyFactor = obj.CriticalSigma/abs(MinimumSig);
                
                obj.m(MaterialIndex,3) = obj.m(MaterialIndex,3) + 0.01;
                
            end
            
            obj.PreStress = obj.m(MaterialIndex,3);
            
            scale = 100; % Set a number to visualize deformed structure properly
            units = 'MPa'; % Define in which units you're providing the stress vector

            Plot = PlotClass();
            Plot.plot2DBars(data,x,Tn,u,CalculatedSigma,scale,units);
            
            else
            
            obj.PreStress = 0;
            
            end

        end

    end
    
end


        