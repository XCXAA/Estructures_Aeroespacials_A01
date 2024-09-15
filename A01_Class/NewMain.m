%% STRUCTURAL PROBLEM CODE STRUCTURE FOLLOWING AN OBJECT-ORIENTED APPROACH

% ToDo:
% FET - Fora comentaris de les classes 
% FET - NewMain passar a Class "gegant"
% FET - Utilitzar class NewMain a tots els unit tests
% FET - Fer dues classes separades per Kelem i Kassembly
% FET - Apply BC com una classe separada
% FET - Aplicar clean code rules de la wiki de Swan a totes les class (only public methods: constructor + compute)

clear
%close all

%% 1) PREPROCESS

% 1.1 Input data (define your input parameters here)
numDOFNodeWheel = 2;  % Degrees of freedom per node

% 1.2 Build geometry (mesh)
% Nodal coordinates matrix
xFrame = [% column_1 = x-coord , column_2 = y-coord , ...    
        0        0
    0.459   -0.054
    1.125        0
    0.315    0.486
    0.864    0.486
];

% Nodal connectivities matrix
Tnframe = [% column_1 = element node 1 , column_2 = element node 2, ...
1 4 %barra 1
1 2 %barra 2
2 4 %barra 3
4 5 %barra 4
2 5 %barra 5
3 5 %barra 6
];


% Material properties matrix
mframe = [% Each column corresponds to a material property (area, Young's modulus, etc.)
    71*10^3 pi*((18.75)^2-(17.25)^2) 0
    71*10^3 pi*((15.6)^2-(14.4)^2) 0
    71*10^3 pi*((10.5)^2-(9.5)^2) 0
];


% Material connectivities matrix
Tmframe = [% Each row is the material (row number in 'm') associated to each element
    3
    3
    2
    2
    1
    1
];

% 1.3 Input boundary conditions
% Fixed nodes matrix
pframe = [% Each row is a prescribed degree of freedom | column_1 = node, column_2 = direction, column_3 = value of prescribed displacement
    1 1 0
    1 2 0
    3 1 0
    3 2 0
];

% Point loads matrix
Fframe = [% Each row is a point force component | column_1 = node, column_2 = direction (1 = x-direction, 2 = y-direction), column_3 = force magnitude
    2 2 -0.45*75*9.81
    4 2 -0.5*75*9.81
    5 2 -0.05*75*9.81
    5 1 75*2.5
];

%% 2) SOLVER

frameInput.numDOFNodeWheel  = numDOFNodeWheel;
frameInput.x                = xFrame;
frameInput.Tn               = Tnframe;
frameInput.m                = mframe;
frameInput.Tm               = Tmframe;
frameInput.p                = pframe;
frameInput.F                = Fframe;

% Direct method
frameInput.solvertype       = "Direct";
newMainObjectDirect = NewMainClass(frameInput);
newMainObjectDirect.compute();

% Iterative method
frameInput.solvertype       = "Iterative";
newMainObjectIterative = NewMainClass(frameInput);
newMainObjectIterative.compute();

%% 3) Test

% Test to ensure that the stiffness matrix has been assembled properly.
stiffnessMatrixTest = StiffnessMatrixTestClass(newMainObjectDirect.outputs);
stiffnessMatrixTest.compute();

%Test to ensure that the total force coincides with the expected value.
totalForceTest = TotalForceTestClass(newMainObjectDirect.outputs);
totalForceTest.compute();

% Test to check if the displacements using whether a Direct or an Iterative
% solver are the same.
% Test to check that the displacements have the expected value using a Direct and an Iterative solver.
displacementsTestInput.uDirect       = newMainObjectDirect.outputs.u;
displacementsTestInput.uIterative    = newMainObjectIterative.outputs.u;

displacementsDITest = DisplacementsDITestClass(displacementsTestInput);
displacementsDITest.compute();

% Test to ensure that the total force coincides with the expected value.
sigmaTestClass = SigmaTestClass(newMainObjectDirect.outputs);
sigmaTestClass.compute();