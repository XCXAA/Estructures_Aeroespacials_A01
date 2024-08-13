%% STRUCTURAL PROBLEM  STIFFNESS MATRIX TEST

clear
close all

%% 1) PREPROCESS

% 1.1 Input data (define your input parameters here)
data.ni = 2;  % Degrees of freedom per node

% 1.2 Build geometry (mesh)
% Nodal coordinates matrix
x = [% column_1 = x-coord , column_2 = y-coord , ...    
        0        0
    0.459   -0.054
    1.125        0
    0.315    0.486
    0.864    0.486
];
data.nnod = size(x,1); % Number of nodes 
data.nd = size(x,2);   % Problem dimension
data.ndof = data.nnod*data.ni;  % Total number of degrees of freedom

% Nodal connectivities matrix
Tn = [% column_1 = element node 1 , column_2 = element node 2, ...
1 4 %barra 1
1 2 %barra 2
2 4 %barra 3
4 5 %barra 4
2 5 %barra 5
3 5 %barra 6
];
data.nel = size(Tn,1); % Number of elements 
data.nne = size(Tn,2); % Number of nodes in a bar

% Create degrees of freedom connectivities matrix
Td = connectDOF(data,Tn);

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

%% 2) SOLVER

% 2.1.1 Compute element stiffness matrices
Kel = stiffnessFunction(data,x,Tn,m,Tm);

% GlobalStiffnessMatrixComputer class
StiffnessMatrix_class = GlobalStiffnessMatrixComputer();
K_class = StiffnessMatrix_class.computeGlobalStiffnessMatrix(data.ni,data.nnod,Td,Kel);

%% 3) Test

% Load the matrix K
load("datas.mat","K");

% Test to ensure that the stiffness matrix has been assembled properly.
assert(all(K == K_class, 'all'),'The stiffness matrix has not been assembled properly')