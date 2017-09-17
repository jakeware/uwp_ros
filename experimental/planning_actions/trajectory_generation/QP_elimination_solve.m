function x_star = QP_elimination_solve(Q,A,b)
% x = QP_elimination_solve(Q,A,b)
% solves a QP min x'Qx s.t. Ax-b=0 by elimination
% assumes the first n culumns of A are lin indep. see 
% p 289 in Bertsekas, Non Linear Programming for details

[m,n] = size(A);

if (m==n) %if we're exactly constrained 
    x_star = A\b;
else

    %partition the A matrix
    B=A(1:m,1:m);
    R=A(1:m,(m+1):end);
    
    Q_BB=Q(1:m,1:m);
    Q_BR=Q(1:m,(m+1):end);
    Q_RB=Q((m+1):end,1:m);
    Q_RR=Q((m+1):end,(m+1):end);
    
    

    f_prime_RR=(2*b'*(B'\(Q_BR-(Q_BB/B)*R)))';
    Q_prime_RR=...
        Q_RR+R'*(B'\Q_BB/B)*R...
        -(R'/B')*Q_BR...
        -(Q_RB/B)*R;

    if rcond(Q_prime_RR)<1e-15
        warning('bad Q_prime_RR')
    end
    x_R_star = -(2*Q_prime_RR)\f_prime_RR;
    x_B_star = B\(b-R*x_R_star);
    x_star = [x_B_star;x_R_star];

end