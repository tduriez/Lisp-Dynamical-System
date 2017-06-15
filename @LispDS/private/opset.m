function ops=opset(range)
%OPSET Private function of the LispDS class. Generates structure of node operators.
%   OPS=OPSET(RANGE) fills the OPS structure using operations defined by
%   list of index RANGE.
%
%   implemented:     - 1  addition       (+)
%                    - 2  substraction   (-)
%                    - 3  multiplication (*)
%                    - 4  division       (%)
%                    - 5  sinus         (sin)
%                    - 6  cosinus       (cos)
%                    - 7  logarithm     (log)
%                    - 8  exp           (exp)
%                    - 9  tanh          (tanh)
%                    - 10 modulo        (mod)
%                    - 11 power         (pow)
%                    - 12 sinh          (sinh)
%                    - 13 cosh          (cosh)
%
%
%   OPS(i).FIELD defines operation i
%
%    FIELD
%     op                  - string used in the LISP expression
%     nbarg               - number of arguments
%     litop               - literal operations performed on arg1, arg2,...
%                           as would be used in MATLAB. This is eventualy
%                           passed to a eval function.
% simplificationcondition - condition on arg1, arg2,... as would be used in
%                           a 'if' statement. Evaluated by eval in the
%                           simplification function. One condition by cell.
%   simplificationaction  - action done when corresponding simplification
%                           condition is met. Always starts with 'newlisp=', a
%                           being the LISP strinf returned. Exemple: the
%                           first condition implemented for the additions
%                           states that if both arg1 and arg2 are numbers
%                           in ASCII then the LISP string is replaced with
%                           the result of the operation in ASCII.
%     derivlisp           - derivative of the LISP expression. darg1,
%                           darg2... are used to express derivatives of
%                           arguments. Exemple d(arg1+arg2)=darg1+darg2,
%                           d(cos(arg1))=darg1*(-sin(arg1))...
%
%   Copyright 


opset(1).Operation='+';
opset(1).nbArguments=2;
opset(1).FormalOperation='arg1 + arg2';
opset(1).SimplificationCondition{1}='1-isnan(str2double(arg1)) && 1-isnan(str2double(arg2))';                  %% both strings are numbers
opset(1).SimplificationAction{1}='newlisp=num2str(str2double(arg1)+str2double(arg2),parameters.precision);';   %% add 2 numbers -> back in string
opset(1).SimplificationCondition{2}='1-isnan(str2double(arg1)) && str2double(arg1)==0';  
opset(1).SimplificationAction{2}='newlisp=arg2;';
opset(1).SimplificationCondition{3}='1-isnan(str2double(arg2)) && str2double(arg2)==0';
opset(1).SimplificationAction{3}='newlisp=arg1;';
opset(1).DerivLisp='(+ darg1 darg2)';
opset(1).Complexity=1;

opset(2).Operation='-';
opset(2).nbArguments=2;
opset(2).FormalOperation='arg1 - arg2';
opset(2).SimplificationCondition{1}='1-isnan(str2double(arg1)) && 1-isnan(str2double(arg2))';
opset(2).SimplificationAction{1}='newlisp=num2str(str2double(arg1)-str2double(arg2),parameters.precision);';
opset(2).SimplificationCondition{2}='1-isnan(str2double(arg2)) && str2double(arg2)==0';
opset(2).SimplificationAction{2}='newlisp=arg1;';
opset(2).SimplificationCondition{3}='strcmp(arg1,arg2)';
opset(2).SimplificationAction{3}='newlisp=num2str(0,parameters.precision);';
opset(2).DerivLisp='(- darg1 darg2)';
opset(2).Complexity=1;

opset(3).Operation='*';
opset(3).nbArguments=2;
opset(3).FormalOperation='arg1 .* arg2';
opset(3).SimplificationCondition{1}='1-isnan(str2double(arg1)) && 1-isnan(str2double(arg2))';
opset(3).SimplificationAction{1}='newlisp=num2str(str2double(arg1)*str2double(arg2),parameters.precision);';
opset(3).SimplificationCondition{2}='(1-isnan(str2double(arg1)) && str2double(arg1)==0) || (1-isnan(str2double(arg2)) && str2double(arg2)==0)';
opset(3).SimplificationAction{2}='newlisp=num2str(0,parameters.precision);';
opset(3).SimplificationCondition{3}='(1-isnan(str2double(arg1)) && str2double(arg1)==1)';
opset(3).SimplificationAction{3}='newlisp=arg2;';
opset(3).SimplificationCondition{4}='(1-isnan(str2double(arg2)) && str2double(arg2)==1)';
opset(3).SimplificationAction{4}='newlisp=arg1;';
opset(3).DerivLisp='(+ (* darg1 arg2) (* arg1 darg2))';
opset(3).Complexity=2;

opset(4).Operation='/';
opset(4).nbArguments=2;
opset(4).protection=0.01;
opset(4).FormalOperation='my_div(arg1,arg2)';
opset(4).SimplificationCondition{1}='1-isnan(str2double(arg1)) && 1-isnan(str2double(arg2))';
opset(4).SimplificationAction{1}=['newlisp=num2str(  str2double(arg1)./(max(abs(str2double(arg2)),' num2str(opset(4).protection) ').*sign(str2double(arg2))),parameters.precision);'];
opset(4).SimplificationCondition{2}='(1-isnan(str2double(arg1)) && str2double(arg1)==0) || (1-isnan(str2double(arg2)) && str2double(arg2)==0)';
opset(4).SimplificationAction{2}='newlisp=num2str(0,parameters.precision);';
opset(4).SimplificationCondition{3}='(1-isnan(str2double(arg2)) && str2double(arg2)==1)';
opset(4).SimplificationAction{3}='newlisp=arg1;';
opset(4).DerivLisp='(- (% darg1 arg2) (* arg1 (% darg2 (% arg2 arg2))))';
opset(4).Complexity=2;

opset(5).Operation='sin';
opset(5).nbArguments=1;
opset(5).FormalOperation='sin(arg1)';
opset(5).SimplificationCondition{1}='1-isnan(str2double(arg1))';
opset(5).SimplificationAction{1}='newlisp=num2str(sin(str2double(arg1)),parameters.precision);';
opset(5).DerivLisp='(* darg1 (cos arg1))';
opset(5).Complexity=5;

opset(6).Operation='cos';
opset(6).nbArguments=1;
opset(6).FormalOperation='cos(arg1)';
opset(6).SimplificationCondition{1}='1-isnan(str2double(arg1))';
opset(6).SimplificationAction{1}='newlisp=num2str(cos(str2double(arg1)),parameters.precision);';
opset(6).DerivLisp='(* darg1 (- 0.00 (sin arg1)))';
opset(6).Complexity=5;

opset(7).Operation='log';
opset(7).nbArguments=1;
opset(7).protection=0.01;
opset(7).SimplificationCondition{1}='1-isnan(str2double(arg1))';
opset(7).SimplificationAction{1}=['newlisp=num2str(log(max(' num2str(opset(7).protection) ',abs(str2double(arg1)))),parameters.precision);'];
opset(7).FormalOperation=['my_log(arg1)'];
opset(7).DerivLisp='(% darg1 arg1)';
opset(7).Complexity=10;

opset(8).Operation='exp';
opset(8).nbArguments=1;
opset(8).FormalOperation='exp(arg1)';
opset(8).SimplificationCondition{1}='1-isnan(str2double(arg1))';
opset(8).SimplificationAction{1}='newlisp=num2str(exp(str2double(arg1)),parameters.precision);';
opset(8).DerivLisp='(* darg1 (exp arg1))';
opset(8).Complexity=10;

opset(9).Operation='tanh';
opset(9).nbArguments=1;
opset(9).FormalOperation='tanh(arg1)';
opset(9).SimplificationCondition{1}='1-isnan(str2double(arg1))';
opset(9).SimplificationAction{1}='newlisp=num2str(tanh(str2double(arg1)),parameters.precision);';
opset(9).DerivLisp='(* darg1 (- 1.00 (* (tanh arg1) (tanh arg1))))';
opset(9).Complexity=5;

opset(10).Operation='mod';
opset(10).nbArguments=2;
opset(10).FormalOperation='my_div(mod(arg1,arg2),arg2)';

opset(11).Operation='pow';
opset(11).nbArguments=2;
opset(11).FormalOperation='my_pow(arg1,arg2)';

opset(12).Operation='sinh';
opset(12).nbArguments=1;
opset(12).FormalOperation='sinh(arg1)';

opset(13).Operation='cosh';
opset(13).nbArguments=1;
opset(13).FormalOperation='cosh(arg1)';

if nargin
    ops=opset(range);
else
    ops=opset;
end
