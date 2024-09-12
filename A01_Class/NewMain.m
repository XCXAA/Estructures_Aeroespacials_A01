%% STRUCTURAL PROBLEM CODE STRUCTURE FOLLOWING AN OBJECT-ORIENTED APPROACH

% ToDo:
% - Fora comentaris de les classes
% - NewMain passar a Class "gegant"
% - Utilitzar class NewMain a tots els unit tests
% - Fer dues classes separades per Kelem i Kassembly
% - Apply BC com una classe separada
% - Aplicar clean code rules de la wiki de Swan a totes les class (only public methods: constructor + compute)

clear
%close all

%% 1) PREPROCESS

% 1.1 Input data (define your input parameters here)
ni_wheel = 2;  % Degrees of freedom per node

% 1.2 Build geometry (mesh)
% Nodal coordinates matrix
x_frame = [% column_1 = x-coord , column_2 = y-coord , ...    
        0        0
    0.459   -0.054
    1.125        0
    0.315    0.486
    0.864    0.486
];

% Nodal connectivities matrix
FrameTn = [% column_1 = element node 1 , column_2 = element node 2, ...
1 4 %barra 1
1 2 %barra 2
2 4 %barra 3
4 5 %barra 4
2 5 %barra 5
3 5 %barra 6
];

% Data Initialization
s.ni = ni_wheel;
s.x = x_frame;
s.Tn = FrameTn;
FrameData = DataClass(s);

% Create degrees of freedom connectivities matrix
TdClass = connectDOFClass();
FrameTd = TdClass.CreateTd(FrameData,FrameTn);

% Material properties matrix
m_frame = [% Each column corresponds to a material property (area, Young's modulus, etc.)
    71*10^3 pi*((18.75)^2-(17.25)^2) 0
    71*10^3 pi*((15.6)^2-(14.4)^2) 0
    71*10^3 pi*((10.5)^2-(9.5)^2) 0
];


% Material connectivities matrix
FrameTm = [% Each row is the material (row number in 'm') associated to each element
    3
    3
    2
    2
    1
    1
];

% 1.3 Input boundary conditions
% Fixed nodes matrix
p_frame = [% Each row is a prescribed degree of freedom | column_1 = node, column_2 = direction, column_3 = value of prescribed displacement
    1 1 0
    1 2 0
    3 1 0
    3 2 0
];

% Point loads matrix
FrameF = [% Each row is a point force component | column_1 = node, column_2 = direction (1 = x-direction, 2 = y-direction), column_3 = force magnitude
    2 2 -0.45*75*9.81
    4 2 -0.5*75*9.81
    5 2 -0.05*75*9.81
    5 1 75*2.5
];

%% 2) SOLVER

% 2.1.1 Compute element stiffness matrices & Assemble global stiffness matrix
StiffnessMatrix = StiffnessMatrixClass();
[FrameKel,FrameK] = StiffnessMatrix.computeStiffnessMatrix(FrameData, FrameTd, x_frame, FrameTn, m_frame, FrameTm);

% 2.1.2 Compute element and total force vectors
FrameForceVectors = ForceVectorsClass();
[Framefel,Framef] = FrameForceVectors.CreateForceVectors(FrameData, x_frame, FrameTm, FrameTn, FrameF, m_frame, FrameTd);

% 2.2 Solve system
solvertype = "Direct";
SolveSystem = SolveSystemClass();
[u_frame,r_frame] = SolveSystem.ComputeSolution(FrameData, p_frame, FrameK, Framef, solvertype);

% 2.5 Compute stress
StressFunction = StressFunctionClass();
sig_frame = StressFunction.ComputeStress(FrameData, x_frame, m_frame, FrameTm, FrameTn, FrameTd, u_frame);

%% 3) POSTPROCESS

FrameScale = 200; % Set a number to visualize deformed structure properly
units = 'MPa'; % Define in which units you're providing the stress vector

Plot = PlotClass();
Plot.plot2DBars(FrameData, x_frame, FrameTn, u_frame, sig_frame, FrameScale, units);


%% Second part (First wheel)

% close all

%% 1) PREPROCESS

% 1.1 Input data (define your input parameters here)
ni_wheel = 2;  % Degrees of freedom per node

% 1.2 Build geometry (mesh)

NumBar = 8; % Number of bars
WheelRadius = 0.35; % wheel radius

NodalCoordinatesMatrix = NodalCoordinatesMatrixClass();
x_wheel1 = NodalCoordinatesMatrix.ComputeMatrix(ni_wheel,WheelRadius,x_frame(1,:),NumBar);

% Nodal connectivities matrix
WheelTn = [% column_1 = element node 1 , column_2 = element node 2, ...
1 2 %barra 1
1 3 %barra 2
1 4 %barra 3
1 5 %barra 4
1 6 %barra 5
1 7 %barra 6
1 8 %barra 7
1 9 %barra 8
2 3 %barra 9
3 4 %barra 10
4 5 %barra 11
5 6 %barra 12
6 7 %barra 13
7 8 %barra 14
8 9 %barra 15
2 9 %barra 16
];

% Data Initialization
s.ni = ni_wheel;
s.x = x_wheel1;
s.Tn = WheelTn;
Wheel1Data = DataClass(s);

% Create degrees of freedom connectivities matrix
WheelTd = TdClass.CreateTd(Wheel1Data, WheelTn);

% Material properties matrix
m_wheel = [% Each column corresponds to a material property (area, Young's modulus, etc.)
    70*10^3 140 0 1470
    210*10^3 3.8 0 1.15
];


% Material connectivities matrix
WheelTm = [% Each row is the material (row number in 'm') associated to each element
    2
    2
    2
    2
    2
    2
    2
    2
    1
    1
    1
    1
    1
    1
    1
    1
];

% 1.3 Input boundary conditions
% Fixed nodes matrix
p_wheel = [% Each row is a prescribed degree of freedom | column_1 = node, column_2 = direction, column_3 = value of prescribed displacement
    6 1 0
    6 2 0
    7 2 0
];

% Point loads matrix
Wheel1F = [% Each row is a point force component | column_1 = node, column_2 = direction (1 = x-direction, 2 = y-direction), column_3 = force magnitude
    1 1 -r_frame(1)
    1 2 -r_frame(2)
];

%% 2) SOLVER

% 2.1.1 Compute element stiffness matrices & Assemble global stiffness matrix
[Wheel1Kel,Wheel1K] = StiffnessMatrix.computeStiffnessMatrix(Wheel1Data, WheelTd, x_wheel1, WheelTn, m_wheel, WheelTm);

% 2.1.2 Compute element and total force vectors
[Wheel1fel,Wheel1f] = FrameForceVectors.CreateForceVectors(Wheel1Data, x_wheel1, WheelTm, WheelTn, Wheel1F, m_wheel, WheelTd);

% 2.2 Solve system
[u_wheel1,r_wheel1] = SolveSystem.ComputeSolution(Wheel1Data, p_wheel, Wheel1K, Wheel1f, solvertype);

% 2.5 Compute stress
Wheel1Sigma = StressFunction.ComputeStress(Wheel1Data, x_wheel1, m_wheel, WheelTm, WheelTn, WheelTd, u_wheel1);

%% 3) POSTPROCESS

WheelScale = 100; % Set a number to visualize deformed structure properly

Plot.plot2DBars(Wheel1Data, x_wheel1, WheelTn, u_wheel1, Wheel1Sigma, WheelScale, units);

%% Second part (Second wheel)

% close all

%% 1) PREPROCESS


% 1.2 Build geometry (mesh)
% Nodal coordinates matrix
x_wheel2 = NodalCoordinatesMatrix.ComputeMatrix(ni_wheel,WheelRadius,x_frame(3,:),NumBar);

% Data Initialization
s.ni = ni_wheel;
s.x = x_wheel2;
s.Tn = WheelTn;
Wheel2Data = DataClass(s);

% Point loads matrix
Wheel2F = [% Each row is a point force component | column_1 = node, column_2 = direction (1 = x-direction, 2 = y-direction), column_3 = force magnitude
    1 1 -r_frame(3)
    1 2 -r_frame(4)
];

%% 2) SOLVER

% 2.1.1 Compute element stiffness matrices & Assemble global stiffness matrix
[Wheel2Kel,Wheel2K] = StiffnessMatrix.computeStiffnessMatrix(Wheel2Data, WheelTd, x_wheel2, WheelTn, m_wheel, WheelTm);

% 2.1.2 Compute element and total force vectors
[Wheel2fel,Wheel2f] = FrameForceVectors.CreateForceVectors(Wheel2Data, x_wheel2, WheelTm, WheelTn, Wheel2F, m_wheel, WheelTd);

% 2.2 Solve system
[u_wheel2,r_wheel2] = SolveSystem.ComputeSolution(Wheel2Data, p_wheel, Wheel2K, Wheel2f, solvertype);

% 2.5 Compute stress
Wheel2Sigma = StressFunction.ComputeStress(Wheel2Data, x_wheel2, m_wheel, WheelTm, WheelTn, WheelTd, u_wheel2);

%% 3) POSTPROCESS

Plot.plot2DBars(Wheel2Data, x_wheel2, WheelTn, u_wheel2, Wheel2Sigma, WheelScale, units);


%% Prestress Calculation

SafetyFactor = 2.5;
MaterialIndex = 2; 

PreStressCalculation = PreStressCalculationClass();
Wheel1Sigma0 = PreStressCalculation.ComputeResult(m_wheel, WheelRadius, Wheel1Data, SafetyFactor, MaterialIndex, Wheel1Sigma, x_wheel1, WheelTn, WheelTm, WheelTd, Wheel1F, p_wheel);
Wheel2Sigma0 = PreStressCalculation.ComputeResult(m_wheel, WheelRadius, Wheel2Data, SafetyFactor, MaterialIndex, Wheel2Sigma, x_wheel2, WheelTn, WheelTm, WheelTd, Wheel2F, p_wheel);
