function [ LSV ] = LSV_Convolution( N, x, lambda, U, C,t)
H = C.*exp(-lambda.*t);
LSV = zeros(N,N);

for n=1:N
    for k = 1:N
        for m=1:N
            h_m = 0;
            for l=1:N
                h_m = h_m + (H(l,1)*U(n,l)*U(m,l)*U(m,k));
            end
            LSV(n,k) = LSV(n,k) + x(m,1)*h_m;
        end
    end
end
end

