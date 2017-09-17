function [p,J] = poly_opt_single(N, tau_final, der_0, der_final, der_costs)
% p = poly_opt_single(N, der_0, der_final, der_costs)
% N, degree of polynomial to optimize
% der_0, derivative vector of constraints at beginning, der_0(1) = polynomial, der_0(2) =
%   first derivative, etc
% der_final, derivative vector of constraints at end
% der_costs, cost vector to be applied to squared derivatives (indexed the
%   same as constraints

N_poly = N+1; %number of terms in polynomial vector
if (length(der_costs)~=N_poly)
    der_costs
    N_poly
    error('must specify cost for each dervative including 0th (N+1)');
end

N_init_constraints=length(der_0); %number of constraints on the beginning of the polynomial
N_final_constraints=length(der_final); %number of constraints on the end of the polynomial
N_B=N_final_constraints+N_init_constraints; %number of constraints
N_R=N_poly-N_B; %number of free parameters

if (N_B>N_poly)
    error('overconstrained');
end

A_0 = poly_opt_single_constraint_init_mat(N, N_init_constraints);
A_final = poly_opt_single_constraint_final_mat(N, N_final_constraints,tau_final);

A=[A_0;A_final];
b=[der_0;der_final];

Q = poly_opt_single_cost_mat(N, tau_final, der_costs);

x_star = QP_elimination_solve(Q,A,b);

J=.5*x_star'*Q*x_star;
p=flipud(x_star);
















