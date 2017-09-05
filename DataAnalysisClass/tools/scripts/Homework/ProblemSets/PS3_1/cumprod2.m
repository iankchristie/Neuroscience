function [ result ] = cumprod2( mat )
%   For vectors, CUMPROD2(X) is a vector containing the cumulative product
%   of the elements of X.  For matrices, CUMPROD2(X) is a matrix the same
%   size as X containing the cumulative products over each column.  For
%   N-D arrays, CUMPROD2(X) operates along the first non-singleton
%   dimension.
%   
%   I decided to call it cumprod2 because cumprod is a built in function
%   and i don't want to override it with my crappy function. Anyway, this
%   doesn't use a running prod like the book does, but it uses the
%   preallocation, which is what we were asked. It uses vector slicing so
%   it sould be faster than the runningsum with less space used too.

[n, m] = size(mat);
if n >= 1 && m >= 1,
    result = ones(n, m);
    result(:, 1) = mat(:, 1);

    for i = 2: m,
        result(:, i) = result(:,i - 1) .* mat(:, i);
    end
end

end

