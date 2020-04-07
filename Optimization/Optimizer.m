% Code for finding optimum values of T/W, and W/S which gives minimum weight
% with all constraints satisfied.
clear
clc
close all

global Aircraft
Aircraft = struct();

LB = [0.1,50];  % Lower Bound
UB = [0.6,160]; % Upper Bound

x0 = [0.25,90]; % Starting Value

A = [];
B = [];
Aeq = [];
Beq = [];

options = optimoptions('fmincon','Algorithm','sqp','Display','iter-detailed',...
    'FunctionTolerance',1e-10,'OptimalityTolerance',1e-20,'ConstraintTolerance',1e-10,....
    'StepTolerance',1e-20);
 
X = fmincon(@(x) Obj_Func(x), x0, A, B, Aeq, Beq, LB, UB, @(x) Nonlincon(x),options);
