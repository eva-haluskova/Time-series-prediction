clear

utok = 2;
% 1 falosne, 2 ts, 3 rozpoznanie
vypis = 3;

switch vypis
    case 1
        load(['C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\skripty\matSubory\utok_',num2str(utok),'_falosne_23_sigma_1024.mat']);
    case 2
        load(['C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\skripty\matSubory\utok_',num2str(utok),'_ts_23_sigma_1024.mat']);
    case 3
        load(['C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\skripty\matSubory\utok_',num2str(utok),'_rozpoznanie_23_sigma_1024.mat']);
end

switch vypis
    case 1
        xp = vysledkyFalosne;
    case 2 
        xp = vysledkyTs;
    case 3
        xp = vysledkyRozpoznanie;
end

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


hold off;

switch vypis
    case 1
        saveas(gcf, ['C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\pca\utok_',num2str(utok),'_falosne_23_1024.png']);
        saveas(gcf, ['C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\pca\utok_',num2str(utok),'_falosne_23_1024.fig']);
    case 2
        saveas(gcf, ['C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\pca\utok_',num2str(utok),'_ts_23_1024.png']);
        saveas(gcf, ['C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\pca\utok_',num2str(utok),'_ts_23_1024.fig']);
    case 3
        saveas(gcf, ['C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\pca\utok_',num2str(utok),'_rozpoznanie_23_1024.png']);
        saveas(gcf, ['C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\pca\utok_',num2str(utok),'_rozpoznanie_23_1024.fig']);
end