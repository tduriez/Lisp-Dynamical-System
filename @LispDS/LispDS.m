classdef LispDS < handle
   properties
       LispExpressions={};
       FormalExpressions={};
       FixedPoints=[];
       Results=[];
       InitialConditions;
       OperationsDefinitions;
   end
   
   methods
       dX=evaluate(obj,X)
       Jac=evaluateJacobian(obj,X)
       obj=findFixedPoints(obj)
       obj=solve(obj)
       obj=solveLyapunov(obj)
       obj=lispToFormal(obj,Mode)
       
       function obj=LispDS(varargin)
           obj.LispExpressions=varargin;
           obj.OperationsDefinitions=opset;
       end
          
           
       
       
   end
    
    
end