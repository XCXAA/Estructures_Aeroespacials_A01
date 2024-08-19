%% STRUCTURAL PROBLEM  STIFFNESS MATRIX TEST

clear
close all

%% 1) PREPROCESS

% 1.1 Input data (define your input parameters here)
ni = 2;  % Degrees of freedom per node

% 1.2 Build geometry (mesh)
% Nodal coordinates matrix
x = [% column_1 = x-coord , column_2 = y-coord , ...    
        0        0
    0.459   -0.054
    1.125        0
    0.315    0.486
    0.864    0.486
];

% Nodal connectivities matrix
Tn = [% column_1 = element node 1 , column_2 = element node 2, ...
1 4 %barra 1
1 2 %barra 2
2 4 %barra 3
4 5 %barra 4
2 5 %barra 5
3 5 %barra 6
];

% Data Initialization
data = DataClass();
data.Init(ni, x, Tn);

% Create degrees of freedom connectivities matrix
TdClass = connectDOFClass();
Td = TdClass.CreateTd(data,Tn);

% Material properties matrix
m = [% Each column corresponds to a material property (area, Young's modulus, etc.)
    71*10^3 pi*((18.75)^2-(17.25)^2) 0
    71*10^3 pi*((15.6)^2-(14.4)^2) 0
    71*10^3 pi*((10.5)^2-(9.5)^2) 0
];


% Material connectivities matrix
Tm = [% Each row is the material (row number in 'm') associated to each element
    3
    3
    2
    2
    1
    1
];

% 1.3 Input boundary conditions
% Fixed nodes matrix
p = [% Each row is a prescribed degree of freedom | column_1 = node, column_2 = direction, column_3 = value of prescribed displacement
    1 1 0
    1 2 0
    3 1 0
    3 2 0
];

% Point loads matrix
F = [% Each row is a point force component | column_1 = node, column_2 = direction (1 = x-direction, 2 = y-direction), column_3 = force magnitude
    2 2 -0.45*75*9.81
    4 2 -0.5*75*9.81
    5 2 -0.05*75*9.81
    5 1 75*2.5
];

%% 2) SOLVER

% 2.1.1 Compute element stiffness matrices
StiffnessMatrix = StiffnessMatrixClass();
[Kel,K_class] = StiffnessMatrix.computeStiffnessMatrix(data, Td, x, Tn, m, Tm);
%% 3) Test

% Standart test
% Load the matrix K
load("datas.mat","K");

% Test to ensure that the stiffness matrix has been assembled properly.
assert(all(K == K_class, 'all'),'The stiffness matrix has not been assembled properly')

% Test following an object-oriented approach
StiffnessMatrixTest = StiffnessMatrixTestClass();
Result = StiffnessMatrixTest.testResult(K_class);
disp(Result);
