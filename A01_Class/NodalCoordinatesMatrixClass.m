classdef NodalCoordinatesMatrixClass < handle

    properties (Access = private)
        InitialAngle
        angle
        x
    end

    properties (Access = private)
        WheelRadius
        Coordinates
        NumBar
    end
    
    methods (Access = public)

        function Result = ComputeMatrix(obj, NumDOFNode, WheelRadius, Coordinates, Numbar)
            obj.Init(NumDOFNode, WheelRadius, Coordinates, Numbar);
            obj.ComputeCoordinates();
            Result = obj.x;
        end

    end


    methods (Access = private)

        function Init(obj, NumDOFNode, WheelRadius, Coordinates, Numbar)
            obj.WheelRadius = WheelRadius;
            obj.Coordinates = Coordinates;
            obj.NumBar = Numbar;
            obj.x = zeros(obj.NumBar,NumDOFNode);
            obj.InitialAngle = 2*pi/obj.NumBar;
            obj.angle = obj.InitialAngle*3/2;
            obj.x(1,:)=[Coordinates(1),Coordinates(2)];
        end

        function ComputeCoordinates(obj)
            for iNumbar = 2:obj.NumBar + 1
    
                obj.x(iNumbar,:) = [cos(obj.angle)*obj.WheelRadius + obj.Coordinates(1), sin(obj.angle)*obj.WheelRadius];
                obj.angle = obj.angle + obj.InitialAngle;
            end 
        end


    end
    
end