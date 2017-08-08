function [x,y,X,Y] = simplex(func, x, kernel, opts, varargin)
%
% SIMPLEX - multidimensional unconstrained non-linear optimsiation多维无约束非线性优化
%
%    X = SIMPLEX(FUNC,X) finds a local minumum of a function, via a function
%    handle FUNC, starting from an initial point X.  The local minimum is
%    located via the Nelder-Mead simplex algorithm [1], which does not require
%    any gradient information.
%
%    [X,Y] = SIMPLEX(FUNC,X) also returns the value of the function, Y, at
%    the local minimum, X.从初始点X开始的局部最小值
%
%    X = SIMPLEX(FUNC,X,OPTS) allows the optimisation parameters to be
%    specified via a structure, OPTS, with members
%
%       opts.Chi         - Parameter governing expansion steps参数管理扩张步骤
%       opts.Delta       - Parameter governing size of initial simplex.初始单纯的参数执政大小。
%       opts.Gamma       - Parameter governing contraction steps.参数管理收缩的步骤。
%       opts.Rho         - Parameter governing reflection steps.参数管理反射的步骤。
%       opts.Sigma       - Parameter governing shrinkage steps.参数管理收缩的步骤。
%       opts.MaxIter     - Maximum number of optimisation steps.优化步骤的最大数量。
%       opts.MaxFunEvals - Maximum number of function evaluations.功能评估的最大数量。
%       opts.TolFun      - Stopping criterion based on the relative change in
%                          value of the function in each step. 基于在相对变化停止准则在每个步骤中的功能的％值。
%       opts.TolX        - Stopping criterion based on the change in the基于在改变停止准则
%                          minimiser in each step.
%      
%    OPTS = SIMPLEX() returns a structure containing the default optimisation
%    parameters, with the following values:
%
%       opts.Chi         = 2
%       opts.Delta       = 0.01
%       opts.Gamma       = 0.5
%       opts.Rho         = 1
%       opts.Sigma       = 0.5
%       opts.MaxIter     = 200
%       opts.MaxFunEvals = 1000
%       opts.TolFun      = 1e-6
%       opts.TolX        = 1e-6
%
%    X = SIMPLEX(FUNC,X,OPTS, P1, P2, ...) allows addinal parameters to be
%    passed to the function to be minimised.
%
%    [X,Y,XX,YY] = SIMPLEX(FUNC, X) also returns in XX all of the values of
%    X evaluated during the optimisation process and in YY the corresponding
%    values of the function.
%
%    References:
%
%       [1] J. A. Nelder and R. Mead, "A simplex method for function
%           minimization", Computer Journal, 7:308-313, 1965.
%
% Description : Simple implementation of the Nelder-Mead simplex optimisation
%               algorithm [1].  Similar to the fminsearch routine from the
%               MATLAB optimisation toolbox.
%
% References  : [1] J. A. Nelder and R. Mead, "A simplex method for function
%                   minimization", Computer Journal, 7:308-313, 1965.
%
% Copyright (c) 2010,  KULeuven-ESAT-SCD, License & help @ http://www.esat.kuleuven.ac.be/sista/lssvmlab

% use default optimisation parameters if none given

if nargin < 4

    opts.Chi         = 2;
    opts.Delta       = 1.2;%0.01;
    opts.Gamma       = 0.5;
    opts.Rho         = 1;
    opts.Sigma       = 0.5;
    opts.MaxIter     = 15;%200;
    opts.MaxFunEvals = 25;
    opts.TolFun      = 1e-6;
    opts.TolX        = 1e-6;

end

% return structure containing default optimisation parameters返回含有默认参数的结构优化

if nargin == 0

    x = opts;

    return

end

% get initial parameters

x = x(:);
n = length(x);
x = repmat(x', n+1, 1);
y = zeros(n+1, 1);

% form initial simplex

for i=1:n

    x(i,i) = x(i,i) + opts.Delta;
    y(i)   = func(x(i,:), varargin{:});

end

y(n+1) = func(x(n+1,:), varargin{:});
X      = x;
Y      = y;
count  = n+1;

[yy, idx] = min(y);
xx        = x(idx,:);

if strcmp(kernel,'RBF_kernel') || strcmp(kernel,'wav_kernel')
    k = 1;
    format = '  % 4d        % 4d     %e     %.4f        %.4f      %s \n';
    fprintf(1, '\n Iteration   Func-count    min f(x)    log(gamma)    log(sig2)    Procedure\n\n');
    fprintf(1, format, 1, count, min(y),xx(1),xx(2),'initial');
elseif strcmp(kernel,'lin_kernel')
    k = 2;
    format = '  % 4d        % 4d     %e     %.4f           %s \n';
    fprintf(1, '\n Iteration   Func-count    min f(x)    log(gamma)      Procedure\n\n');
    fprintf(1, format, 1, count, min(y),xx(1),'initial');
elseif strcmp(kernel,'poly_kernel')
    k = 3;
    format = '  % 4d        % 4d     %e     %.4f         %.4f         %s   \n';
    fprintf(1, '\n Iteration   Func-count    min f(x)    log(gamma)      log(t)        Procedure\n\n');
    fprintf(1, format, 1, count, min(y),xx(1),xx(2),'initial');
end



% iterative improvement迭代改进

for i=2:opts.MaxIter

    % order

    [y,idx] = sort(y);
    x       = x(idx,:);%根据y里面数据大小的顺序对x排序

    % reflect映射？？？

    centroid = mean(x(1:end-1,:));
    x_r      = centroid + opts.Rho*(centroid - x(end,:));%平均值减去最后的值再加上平均值
    y_r      = func(x_r, varargin{:});%以x_r作为输入调用成本函数（优化？？）
    count    = count + 1;
    X        = [X ; x_r];
    Y        = [Y ; y_r];%分别添加计算得到的值

    if y_r >= y(1) && y_r < y(end-1)

        % accept reflection point接受映射点

        x(end,:) = x_r;
        y(end)   = y_r;
        [yy, idx] = min(y);
        xx = x(idx,:);
        if k==1 || k==3
            fprintf(1, format, i, count, min(y),xx(1),xx(2),'reflect');
        elseif k==2
            fprintf(1, format, i, count, min(y),xx(1),'reflect');
        end
            

    else

        if y_r < y(1)

            % expand扩大

            x_e   = centroid + opts.Chi*(x_r - centroid);
            y_e   = func(x_e, varargin{:});
            count = count + 1;
            X     = [X ; x_e];
            Y     = [Y ; y_e];

            if y_e < y_r

                % accept expansion point接受扩展点

                x(end,:) = x_e;
                y(end)   = y_e;
                [yy, idx] = min(y);
                xx = x(idx,:);
                if k==1 || k==3
                   fprintf(1, format, i, count, min(y),xx(1),xx(2), 'expand');
                elseif k==2
                   fprintf(1, format, i, count, min(y),xx(1), 'expand');
                end
                
            else

                % accept reflection point接受反射点

                x(end,:) = x_r;
                y(end)   = y_r;
                [yy, idx] = min(y);
                xx = x(idx,:);
                if k==1 || k==3
                   fprintf(1, format, i, count, min(y),xx(1),xx(2), 'reflect');
                elseif k==2
                   fprintf(1, format, i, count, min(y),xx(1), 'reflect');
                end
                

            end

        else

            % contract契约

            shrink = 0;

            if y(end-1) <= y_r && y_r < y(end)

                % contract outside

                x_c   = centroid + opts.Gamma*(x_r - centroid);
                y_c   = func(x_c, varargin{:});
                count = count + 1;
                X     = [X ; x_c];
                Y     = [Y ; y_c];

                if y_c <= y_r

                    % accept contraction point

                    x(end,:) = x_c;
                    y(end)   = y_c;
                    [yy, idx] = min(y);
                    xx = x(idx,:);
                    if k==1 || k==3 
                        fprintf(1, format, i, count, min(y),xx(1),xx(2),'contract outside');
                    elseif k==2
                        fprintf(1, format, i, count, min(y),xx(1),'contract outside');
                    end
                    
                else

                    shrink = 1;

                end

            else

                % contract inside收缩里面

                x_c   = centroid + opts.Gamma*(centroid - x(end,:));%centroid在开始之后没有变化
                y_c   = func(x_c, varargin{:});
                count = count + 1;
                X     = [X ; x_c];
                Y     = [Y ; y_c];

                if y_c <= y(end)

                    % accept contraction point

                    x(end,:) = x_c;
                    y(end)   = y_c;%限定最大值为 x_c、y_c
                    [yy, idx] = min(y);
                    xx = x(idx,:);
                    if k==1 || k==3 
                        fprintf(1, format, i, count, min(y),xx(1),xx(2),'contract inside');
                    elseif k==2 
                        fprintf(1, format, i, count, min(y),xx(1),'contract inside');
                    end
                    
                else

                    shrink = 1;%又置为1？、进入下一个if

                end

            end

            if shrink

                % shrink

                for j=2:n+1

                    x(j,:) = x(1,:) + opts.Sigma*(x(j,:) - x(1,:));%第二个点进行更新（原x内部？）
                    y(j)   = func(x(j,:), varargin{:});%同理
                    count  = count + 1;
                    X      = [X ; x(j,:)];
                    Y      = [Y ; y(j)];%将得到的点值加入XY中

                end
                [yy, idx] = min(y);
                xx = x(idx,:);%更新 xx、yy的值
                if k==1 || k==3 
                    fprintf(1, format, i, count, min(y),xx(1),xx(2),'shrink');
                elseif k==2
                    fprintf(1, format, i, count, min(y),xx(1),'shrink');
                end
                

            end

        end

    end

    % evaluate stopping criterion评估停止准则

    if max(abs(min(x) - max(x))) < opts.TolX

        fprintf(1, 'optimisation terminated sucessfully (TolX criterion)\n');

        break;

    end

    if abs(max(y) - min(y))/max(abs(y))  < opts.TolFun

        fprintf(1, 'optimisation terminated sucessfully (TolFun criterion)\n\n');

        break;

    end
    if count  > opts.MaxFunEvals

        fprintf(1, 'optimisation terminated sucessfully (MaxFunEvals criterion)\n\n');

        break;

    end

end

if i == opts.MaxIter

    fprintf(1, 'Warning : maximim number of iterations exceeded\n\n');

end

% update model structure更新

[y, idx] = min(y);
x        = x(idx,:);

% bye bye...

