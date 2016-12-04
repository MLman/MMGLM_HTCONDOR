%Om Shanti.
%November 7, 2013.
%Nagesh Adluru.
%p-value histograms wrapper.

function pval_hist_wrapper(dti_nii,fa_nii,fa_smth_nii,wm_idx,title_str,fname)
figure(1);clf(1);
set(gcf,'color','w');set(gca,'fontweight','b','fontsize',16,'xtick',0:0.1:1.0);grid on;hold on;
[nfa,xcenters]=hist(1-fa_nii.vol(wm_idx));
nodf=hist(1-dti_nii.vol(wm_idx),xcenters);
nfa_smth=hist(1-fa_smth_nii.vol(wm_idx),xcenters);
plot(xcenters,nodf,'b','linewidth',2);
plot(xcenters,nfa,'r','linewidth',2);
plot(xcenters,nfa_smth,'color','g','linewidth',2);
legend('MGLM (ODF)','GLM (FA)','GLM (FA-smoothed)','location','south');
set(gca,'xlim',[min(xcenters) max(xcenters)]);
set(gca,'ytick',0:10000:150000,'yticklabel',{'0','10000','20000','30000','40000','50000','60000','70000','80000','90000','100000','110000','120000','130000','140000','150000'});
xlabel('p-values');ylabel('# of voxels');title(title_str);
print(gcf,'-r300','-dpng',fname)



%FDR.
alp=0.05;
numTests=length(wm_idx);
pvals=sort(fa_nii.vol(wm_idx))';
[pID,pN]=FDR(alp,pvals);
fprintf('\nFA - %d %d',length(pID),length(pN));
pvals=sort(fa_smth_nii.vol(wm_idx))';
[pID,pN]=FDR(alp,pvals);
fprintf('\nFA-smth - %d %d',length(pID),length(pN));

pvals=sort(dti_nii.vol(wm_idx))';
[pID,pN]=FDR(alp,pvals);
fprintf('\nODF - %d %d',length(pID),length(pN));
return