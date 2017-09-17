function A_init = poly_opt_single_constraint_init_mat(N, N_init_constraints, t_scale)
% A_init = poly_opt_single_constraint_init_mat(N, N_init_constraints)
% A_init: derivative contraint matrix on coefficients of polynomial 
%   Ap = vector of derivatives at t=0
% N: degree of polynomial
% N_init_contraints: number of contraints, equal to order of derivative
%   minus 1
% t_scale: scaling of t inside polynomial

if nargin<3
    t_scale=1;
end
N_poly = N+1; %number of terms in polynomial vector

A_init = zeros(N_init_constraints,N_poly);
for rr=1:N_init_constraints
    r=rr-1;
    prod = 1;
    for m=0:(r-1)
        prod=prod*(r-m)/t_scale;
    end
    A_init(rr,rr)=prod;
end