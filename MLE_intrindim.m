function d_hat = MLE_intrindim(X, k)

%========================================================================
% Input Args.
% X: columnwise points
% k: number of neighbors

% Output Arg.
% d_hat: estimated intrinsic dimension

% Author: Shengchao Zhang
%         shengchao.zhang@vanderbilt.edu
%========================================================================

% Transposing the data matrix to be fed into knnsearch algorithm
X = X';
X = double(unique(X, 'rows'));   % Remove the duplicate data points
[~, dists] = knnsearch(X,X,'K',k);

temp1 = dists(:, 2:end); % Cropping the distances matrix

Tk = dists(:, end);
Tk_Tj = log((repmat(Tk, [1, size(temp1, 2)])) ./ temp1);
Tk_Tj(:, any(isinf(Tk_Tj),1)) = [];

d_hatk = ((1 / (k-1)) * sum(Tk_Tj, 2)) .^ (-1);

d_hat = mean(d_hatk);

end