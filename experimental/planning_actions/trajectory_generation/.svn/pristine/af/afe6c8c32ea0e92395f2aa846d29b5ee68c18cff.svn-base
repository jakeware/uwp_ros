function derivatives = poly_get_derivatives(poly,tau,D)

poly_copy = poly;

derivatives = zeros(D,length(tau));

% if length(tau)>1
for ii=1:D
    derivatives(ii,:) = polyval(poly_copy,tau);
    poly_copy = polyder(poly_copy);
end
% else
%     for derivative = 0:D-1
%         val = 0;
%         for nn = derivative:length(poly)-1
%             prod = 1;
%             for mm = 0:derivative-1
%                 prod =prod *(nn - mm);
%             end
%             val = val+ poly(nn+1) * prod * tau^(nn - derivative);
%         end
%         derivatives(derivative+1)=val;
%     end
% end
%     