function obj=lispToFormal(obj,Mode)
for i=1:numel(obj.LispExpressions)
    obj.FormalExpressions{i}=lispToFormal(obj.LispExpressions{i},obj.OperationsDefinitions,Mode);
end
end