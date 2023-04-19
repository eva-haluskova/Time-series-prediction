clear
load("C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\skripty\matSubory\utok_2_falosne_23_sigma_1024.mat")
xp = vysledkyFalosne;
mi = min(xp);
xp = [xp;mi];

x=xp-mean(xp);

R = cov(x);
[U,S,V] = svd(R);

diag(S);
c = x*U;
figure
hold on;

title('Pca\_utok\_cw\_1024')

%{
plot(c(1,1),c(1,2),'or')
plot(c(2,1),c(2,2),'*r')
plot(c(3,1),c(3,2),'pr')
plot(c(4,1),c(4,2),'xr')
plot(c(5,1),c(5,2),'^r')
plot(c(6,1),c(6,2),'ob')
plot(c(7,1),c(7,2),'*b')
plot(c(8,1),c(8,2),'pb')
plot(c(9,1),c(9,2),'xb')
plot(c(10,1),c(10,2),'^b')
plot(c(11,1),c(11,2),'ok')
plot(c(12,1),c(12,2),'*k')
plot(c(13,1),c(13,2),'pk')
plot(c(14,1),c(14,2),'xk')
plot(c(15,1),c(15,2),'^k')
plot(c(16,1),c(16,2),'sg')
%}

hold off;

saveas(gcf, 'pca_utok_8_roz2_1024.png');
saveas(gcf, 'pca_utok_8_roz2_1024.fig')