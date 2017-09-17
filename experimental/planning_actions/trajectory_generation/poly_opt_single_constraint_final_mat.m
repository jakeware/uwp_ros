function A_final = poly_opt_single_constraint_final_mat(N, N_final_constraints, tau_final, t_scale)
% A_final = poly_opt_single_constraint_final_mat(N, N_final_constraints, tau_final)
% A_final: derivative contraint matrix on coefficients of polynomial Ap = vector of derivatives at tau_final
% N: degree of polynomial
% N_final_contraints: number of contraints, equal to order of derivative
%   minus 1
% t_scale: scaling of t for polynomail

if nargin<4
    t_scale=1;
end

N_poly = N+1; %number of terms in polynomial vector

A_final= zeros(N_final_constraints,N_poly);
for rr=1:N_final_constraints
    for nn=1:N_poly
        r=rr-1;
        n=nn-1;
        if (n>=r)
            prod = 1;
            for m=0:(r-1)
                prod=prod*(n-m)/t_scale;
            end
            A_final(rr,nn)=prod*tau_final^(n-r);
        end
    end
end