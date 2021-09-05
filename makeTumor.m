function tumor = makeTumor(h, k, a, b, S)
%MAKETUMOR Summary of this function goes here
%   Detailed explanation goes here
tumor = struct;

tumor.h = h; % x offset
tumor.k = k; % y offset
tumor.a = a;
tumor.b = b;
tumor.S = S; % the tumor's generalized scattering parameter
end

