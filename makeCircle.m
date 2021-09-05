function S = makeCircle(xRange, yRange, radius, n, tumors)
% MAKECIRCLE Makes a 2D matrix that represents circle.
%   TODO: Check/better handle for overlapping tumors?
S = zeros(n);
for i = 1:n
    for j = 1:n
        % j corresponds to the column of S
        % i corresponds to the row of S
        x = xRange(j);
        y = yRange(i);
        didSet = false;
        
        % If the point is in the circle.
        if inCircle(x, y, radius)
            % Loop through the tumors
            for tumor = tumors
                % If point i, j is in the tumor
                if inEllipse(x, y, tumor.h, tumor.k, tumor.a, tumor.b)
%                 if inCircle(x-tumor.x, y-tumor.y, tumor.radius)
                    % Set the S value for the tumor.
                    S(i, j) = tumor.S;
                    % Makes it so that the S value is not overriden after
                    % the tumors loop is broken.
                    didSet = true;
                    % No need to check other tumors.  For overlapping
                    % tumors, the first tumor in the tumors array will be
                    % used.
                    break
                end % if point is in a tumor
            end % for tumor
            
            % If point i, j hasn't already been set in the tumor loop, that
            % means the point is in the circle, but not in a tumor.
            % Specifies to set to water.
            if ~didSet
                % TODO: Get the correct water S value.
                S(i, j) = 0.05;
            end
        else
            % The point is not in the circle, set S to 0 (or possible air?)
            % TODO: Consider air/machine equipment etc
            S(i, j) = 0;
        end % if point is in the circle
    end % for j
end % for i
end % function makeCircle

function inEllipse = inEllipse(x, y, h, k, a, b)
firstTerm = (x-h)/a;
firstTerm2 = firstTerm^2;
secondTerm = (y-k)/b;
secondTerm2 = secondTerm^2;
inEllipse = (firstTerm2 + secondTerm2) < 1;
end % function inEllipse

function inCircle = inCircle(x, y, r)
    inCircle = x^2 + y^2 < r^2;
end % function inCircle