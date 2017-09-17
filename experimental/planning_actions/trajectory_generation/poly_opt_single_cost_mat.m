function Q = poly_opt_single_cost_mat(N, tau_final, der_costs)
% Q = poly_opt_single_cost_mat(N, tau_final, der_costs)
% quadratic cost matrix on coefficients of polynomial of degree N
% J=\int_0^\tau_final P(t)^2dt=p'Qp where p is the vector of polynomial
% der_costs, cost vector to be applied to squared derivatives 
%   der_0(1) = polynomial, der_0(2) = first derivative, etc

N_poly = N+1; %number of terms in polynomial vector

Qs=zeros(N_poly,N_poly,N_poly);

for rr=1:N_poly
    for ii=1:N_poly
        for ll=1:N_poly
            i=ii-1;
            l=ll-1;
            r=rr-1;
            if (i>=r && l>=r)
                prod = 1;
                for m=0:(r-1)
                    prod=prod*(i-m)*(l-m);
                end
                Qs(ii,ll,rr) = der_costs(rr)^2*2*prod*tau_final^(l+i+1-2*r) / (l+i+1-2*r);
            end
        end
    end
end

Q = sum(Qs,3);
