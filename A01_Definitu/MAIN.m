%% STRUCTURAL PROBLEM CODE STRUCTURE

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
Kel = stiffnessFunction(data,x,Tn,m,Tm);

% 2.1.2 Compute element force vectors
fel = forceFunction(data,x,Tn,m,Tm); 

% 2.2 Assemble global stiffness matrix
[K,f] = assemblyFunction(data,Td,Kel,fel);

% GlobalStiffnessMatrixComputer class
StiffnessMatrix_class = GlobalStiffnessMatrixComputer();
K_class = StiffnessMatrix_class.computeGlobalStiffnessMatrix(data.ni,data.nnod,Td,Kel);

% 2.3.1 Apply prescribed DOFs
[up,vp] = applyBC(data,p);

% 2.3.2 Apply point loads
f = pointLoads(data,Td,f,F);

solvertype = "Direct";
% 2.4 Solve system
[u,r] = solveSystem(data,K,f,up,vp,solvertype);

% 2.5 Compute stress
sig = stressFunction(data,x,Tn,m,Tm,Td,u);

%% 3) POSTPROCESS

scale = 200; % Set a number to visualize deformed structure properly
units = 'MPa'; % Define in which units you're providing the stress vector

plot2DBars(data,x,Tn,u,sig,scale,units);
%% Seconde part (First wheel)

%close all

%% 1) PREPROCESS

% 1.1 Input data (define your input parameters here)
data.ni = 2;  % Degrees of freedom per node

% 1.2 Build geometry (mesh)

n_b=8; % Number of bars
R_w=0.35; % wheel radius

% Nodal coordinates matrix
[x_1]=nodal_2(n_b,data,R_w,x(1,:));
data.nnod = size(x_1,1); % Number of nodes 
data.nd = size(x_1,2);   % Problem dimension
data.ndof = data.nnod*data.ni;  % Total number of degrees of freedom

% Nodal connectivities matrix
Tn_1 = [% column_1 = element node 1 , column_2 = element node 2, ...
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
data.nel = size(Tn_1,1); % Number of elements 
data.nne = size(Tn_1,2); % Number of nodes in a bar

% Create degrees of freedom connectivities matrix
Td_1 = connectDOF(data,Tn_1);

% Material properties matrix
m_1 = [% Each column corresponds to a material property (area, Young's modulus, etc.)
    70*10^3 140 0 1470
    210*10^3 3.8 0 1.15
];


% Material connectivities matrix
Tm_1 = [% Each row is the material (row number in 'm') associated to each element
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
p_1 = [% Each row is a prescribed degree of freedom | column_1 = node, column_2 = direction, column_3 = value of prescribed displacement
    6 1 0
    6 2 0
    7 2 0
];

% Point loads matrix
F_1 = [% Each row is a point force component | column_1 = node, column_2 = direction (1 = x-direction, 2 = y-direction), column_3 = force magnitude
    1 1 -r(1)
    1 2 -r(2)
];

%% 2) SOLVER

% 2.1.1 Compute element stiffness matrices
Kel = stiffnessFunction(data,x_1,Tn_1,m_1,Tm_1);

% 2.1.2 Compute element force vectors
fel = forceFunction(data,x_1,Tn_1,m_1,Tm_1); 

% 2.2 Assemble global stiffness matrix
[K,f] = assemblyFunction(data,Td_1,Kel,fel);

% 2.3.1 Apply prescribed DOFs
[up,vp] = applyBC(data,p_1);

% 2.3.2 Apply point loads
f = pointLoads(data,Td_1,f,F_1);

% 2.4 Solve system
[u_1,r_1] = solveSystem(data,K,f,up,vp);

% 2.5 Compute stress
sig_1 = stressFunction(data,x_1,Tn_1,m_1,Tm_1,Td_1,u_1);

%% 3) POSTPROCESS

scale = 100; % Set a number to visualize deformed structure properly
units = 'MPa'; % Define in which units you're providing the stress vector

plot2DBars(data,x_1,Tn_1,u_1,sig_1,scale,units);

%% Seconde part (Second wheel)

%close all

%% 1) PREPROCESS

% 1.1 Input data (define your input parameters here)

% 1.2 Build geometry (mesh)
% Nodal coordinates matrix
[x_2]=nodal_2(n_b,data,R_w,x(3,:));

% Point loads matrix
F_2 = [% Each row is a point force component | column_1 = node, column_2 = direction (1 = x-direction, 2 = y-direction), column_3 = force magnitude
    1 1 -r(3)
    1 2 -r(4)
];

%% 2) SOLVER

% 2.1.1 Compute element stiffness matrices
Kel = stiffnessFunction(data,x_2,Tn_1,m_1,Tm_1);

% 2.1.2 Compute element force vectors
fel = forceFunction(data,x_2,Tn_1,m_1,Tm_1); 

% 2.2 Assemble global stiffness matrix
[K,f] = assemblyFunction(data,Td_1,Kel,fel);

% 2.3.1 Apply prescribed DOFs
[up,vp] = applyBC(data,p_1);

% 2.3.2 Apply point loads
f = pointLoads(data,Td_1,f,F_2);

% 2.4 Solve system
[u_2,r_2] = solveSystem(data,K,f,up,vp);

% 2.5 Compute stress
sig_2 = stressFunction(data,x_2,Tn_1,m_1,Tm_1,Td_1,u_2);

%% 3) POSTPROCESS

scale = 100; % Set a number to visualize deformed structure properly
units = 'MPa'; % Define in which units you're providing the stress vector

plot2DBars(data,x_2,Tn_1,u_2,sig_2,scale,units);

sf=2.5; %Safety factor
e=2; %Material index

%Critical tension
sig_cs=(pi^2*m_1(2,1).*m_1(2,4))/(m_1(2,2).*(R_w*10^3)^2);
%fs=sig_cs/min(sig_1(:))

%Prestress (initial stress) in the spokes
[sig_1_0]=prestress_calculation(sig_1,Kel,data,x_1,Tn_1,m_1,Tm_1,Td_1,F_1,p_1,sig_cs,e,sf);
[sig_2_0]=prestress_calculation(sig_2,Kel,data,x_2,Tn_1,m_1,Tm_1,Td_1,F_2,p_1,sig_cs,e,sf);

