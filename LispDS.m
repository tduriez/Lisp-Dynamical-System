classdef LispDS < handle
   properties
       Expressions={};
       FixedPoints=[];
       Results=[];
   end
   
   methods
       dX=evaluate(obj,X)
       Jac=evaluateJacobian(obj,X)
       obj=findFixedPoints(obj)
       obj=solve(obj)
       obj=solveLyapunov(obj)
       
       function obj=LispDS(varargin)
           obj.Expressions=varargin;
       end
          
           
       
       
   end
    
    
end