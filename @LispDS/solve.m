function obj=solve(obj)
    obj.lispToFormal(1);
    nbDims=numel(obj.LispExpressions);
    eval(['DevFunc=@(t,x)(' makeAnonymousFunction(obj.FormalExpressions) ');']);
    if isempty(obj.InitialConditions)
        obj.InitialConditions=zeros(nbDims,1);
    end
    
    [T,X]=ode45(DevFunc,[0 100],obj.InitialConditions);
    obj.Results.T=T;
    obj.Results.X=X;
end

function FunctionString=makeAnonymousFunction(Expressions)
    FunctionString='';
    for i=1:length(Expressions)
        if isempty(FunctionString)
            FunctionString=sprintf('%s',Expressions{i});
        else
            FunctionString=sprintf('%s;%s',FunctionString,Expressions{i});
        end
    end
    FunctionString=['[' FunctionString ']']
end





        
    