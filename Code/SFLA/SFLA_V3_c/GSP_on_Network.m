function [U, lambda] = GSP_on_Network( w_method )
load('dis_new.mat');

if w_method==1
    %Create Adjacency Matrix
    for row=1:63
        for col=1:63
            if row ~= col
                W(row,col) = 1/dis_new(row,col);
            else
                W(row,col) = 0;
            end
        end
    end
    
    %Create Diagonal Matrix
    D = diag(sum(W,2));
    
    %Create Laplacian Matrix
    L = D-W;
    
    %Calculate Eigenvalues and Eigenvectors of L
    [U,D] = eig(L);
    lambda = diag(D);

end

% %%Draw Distance Matrix
% fig1 = figure; hold on;
% title('Distance Matrix');
% imagesc(dis_new);
% colorbar;
% xlim([1 63]);
% ylim([1 63]);
% 
%     Plot Adjacency Matrix
%     fig2 = figure; hold on;
%     title('Adjacency Matrix');
%     imagesc(W);
%     colorbar;
%     xlim([1 63]);
%     ylim([1 63]);
end