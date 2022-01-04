function [C, INDSORT] = communityBetStates(transMat, transMATFull)

%========================================================================
% Input Args.
% transMat: transition probability matrix whose diagonal elements should be
% removed, since this function focus on between-state transitioning
% transMATFull: the full transition probability matrix whose diagonal
% elements are preserved for aiding the visualization for this function

% Output Args.
% C: the community affiliation vector for detected communities
% INDSORT: the indices of the original states after the community detection

% Output Fig.
% The detected communities

% This function depends on BCT toolbox
% Complex network measures of brain connectivity: Uses and interpretations.
% Rubinov M, Sporns O (2010) NeuroImage 52:1059-69.

% The visualization of this function depends on cbrewer toolbox
% Charles (2021). cbrewer : colorbrewer schemes for Matlab 
% MATLAB Central File Exchange

% Author: Shengchao Zhang
%         shengchao.zhang@vanderbilt.edu
%========================================================================

C = community_louvain(transMat);
[X,Y,INDSORT] = grid_communities(C);

%Insert the diagonal elements for aiding the visualization
temp = eye(size(M, 1));
for i = 1:length(INDSORT)
    t = INDSORT(i);
    temp(i, i) = transMATFull(t, t);
end

% First fig shows the detected communities
figure(1)
set(gcf,'color','w');
imagesc(transMat(INDSORT, INDSORT) + temp)
my_cmap = cbrewer('seq','YlOrRd',9);
% colormap(flipud(mycmap))
% colormap(jet(256));
colormap(my_cmap);
set(gca, 'xtick', [])
set(gca, 'ytick', [])
colorbar
caxis([0, 0.06])
hold on 
plot(X,Y,'b--','linewidth',4)
ylabel('State (from)')
xlabel('State (to)')
title('Community Detection')
axis square
% set(gca, 'fontsize', 48)
% set(gca,'fontname','times') 
% set(gcf, 'position', [80 105 1471 839])

end