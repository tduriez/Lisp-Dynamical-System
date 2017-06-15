%LISPTOFORMAL    Transform LISP expression in formal MATLAB. Private
%function
%
% FORMALEXPR =  LISPTOFORMAL(LISPEXPR,OPDEF)
%
%           LISPEXPR:          string with FormalExpr LISP expression (ex: (+ 1 2)).
%           OPDEF:             operation definition object (optionnal).
%           FORMALEXPR:        string with FormalExpr MATLAB valid expression.
%
% COPYRIGHT

function [ FormalExpression ] = lispToFormal(LispExpression,OperationsDefinitions,sEval)

if nargin<3
    sEval=0;
end
    

iSpaces=strfind(LispExpression,' ');
if isempty(iSpaces) % There is no operand
    while strcmp(LispExpression(1),'(');
        LispExpression=removeParenthesis(LispExpression);
    end
    
    
    if strcmp(LispExpression(1),'-');
        FormalExpression = addParenthesis(LispExpression);
    elseif strcmp(LispExpression(1),'x') && sEval==1
        nVar=LispExpression(2:end);
        FormalExpression = sprintf('x(%s)',nVar);
    else
        FormalExpression = LispExpression;
    end
    
else
    Operand=LispExpression(2:iSpaces(1)-1);
    iArguments=getSpacesOfDepthOne(LispExpression);
    for i=1:length(OperationsDefinitions)
        if strcmp(OperationsDefinitions(i).Operation,Operand)
            FormalExpression = OperationsDefinitions(i).FormalOperation;
            for j=1:OperationsDefinitions(i).nbArguments;
                FormalExpression = strrep(FormalExpression,sprintf('arg%d',j),...
                    lispToFormal(LispExpression(iArguments(j)+1:iArguments(j+1)-1),...
                    OperationsDefinitions,sEval));
            end
            if OperationsDefinitions(i).nbArguments>1
                FormalExpression=addParenthesis(FormalExpression);
            end
        end
    end
end
end


function Expr=addParenthesis(Expr)
Expr=['(' Expr ')'];
end

function Expr=removeParenthesis(Expr)
if strcmp(Expr(1),'(') && strcmp(Expr(end),')')
    Expr=Expr(2:end-1);
end
end

function iSpacesDepthOne=getSpacesOfDepthOne(Expr)
ValOpenPar= double('(');
ValClosePar=double(')');
ValSpace=   double(' ');
OpeningPars=cumsum(double(double(Expr)==ValOpenPar));
ClosingPars=cumsum(double(double(Expr)==ValClosePar));
Spaces=double(double(Expr==ValSpace));
iSpacesDepthOne=find(((OpeningPars-ClosingPars).*Spaces)==1);
iSpacesDepthOne=[iSpacesDepthOne length(Expr)];
end





