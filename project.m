% Formatting
format shortE

% Some constants
n = 1000;
xMin = -2;
xMax = 2;
yMin = -2;
yMax = 2;
radius = 1;

% For plotting
figNum = 1;

% The range of x and y values in the circle.
xRange = linspace(xMin, xMax, n);
yRange = linspace(yMin, yMax, n);

% Create some tumors which are injected into the circle.
% TODO: Overlapping tumor prevention?
tumor1 = makeTumor(0.55, -0.25, 1/8, 2/8, 0.1);
tumor2 = makeTumor(0.4, 0.4, 1/5, 1/10, 0.2);
tumor3 = makeTumor(-0.3, -0.7, 3/20, 3/20, 0.15);
tumors = [tumor1, tumor2, tumor3];

% The generalized scattering parameter for each pixel
% TODO: Make 3D using voxels
S = makeCircle(xRange, yRange, radius, n, tumors);

% Plot S
figure(figNum)
figNum = figNum + 1;
imagesc(xRange, yRange, S)
axis xy % Sets the correct axis range.
title("Generalized Scattering Parameter")
xlabel("x")
ylabel("y")
colorbar

% Sum will sum each column of the matrix and form a row vector. Each column
% corresponds to an x-coordinate.
% This is the integral of each parallel x-ray beam.
% TODO: This will change for alternative beam-geometries.
%    For cone-beam, need to consider integrating S for many different
%    angles, one for each detector pixel.
% In general, we should consider using many more actual pixels than
% detector pixels, since the real world's pixels (molecules) are much smaller
% than pixels in detectors. For that, will we integrate over all S pixels
% that fit within the detector pixel?
variance = sum(S);

% Plot the variance vs. x
figure(figNum)
figNum = figNum + 1;
plot(xRange, variance)
title("Variance vs. x")
xlabel("x")
ylabel("Variance")
axis padded

% It's a little easier to create an additional sigma column vector.
sigma = variance.^(0.5);

% Arbitrary z0.
z0 = 1;
% f matrix will be the Gaussian PDF for each variance/sigma value.
f = zeros(n);
for i = 1:n
    % for the i'th row, set the column as the kernel for the sigma value
    % that corresponds to that column.
    f(i, :) = normpdf(xRange, 0, sigma(i));
end % for i

% Plot the f surface.
% I don't fully understand this.
figure(figNum)
figNum = figNum + 1;
surf(xRange, variance, f)
xlabel("x")
ylabel("Variance")
zlabel("f (Gaussian PDF Kernel)")

% Arbitrary signal (previously mentioned that is should be ~20 or 30% bias,
% but I'm not sure of the best way to model that, so for now I'll just use
% a sin.
% It should probably also be a signal as a function of x.
signal = sin(xRange.*10);

% This isn't entirely right.
% The convolution should be run for each x value (as is currently done).
% The signal will also be different for each x-value.
% But that can be updated later.
convolution = zeros(n);
for i = 1:n
    % TODO: Update signal to be a signal for each x-value.
    convolution(i, :) = conv(f(i), signal);
end

% Plot the convolution surface.
% I don't fully understand this.
figure(figNum)
figNum = figNum + 1;
surf(xRange, variance, convolution)
title("Convolution")
xlabel("x")
ylabel("variance")
zlabel("Convolution of signal (sine) with Gaussian PDF Kernel")

figure(figNum)
figNum = figNum + 1;
plot(signal)