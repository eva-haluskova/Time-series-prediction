% Vytvorenie 2sigma tunelu; zo 100 hodnoôt procesu vypočítame strednú
% hodnotu a odchylku. Zisťujeme, či 101 hodnota patrí do interválu 
% I = <str.hodnota - 2*odchylka, str.hodnota + 2*odchylka> 
% Posúvame okno vždy o jedna a prepočítavame hodnoty nanovo.

clear
% nacitanie parametra
load("C:\Users\eva\OneDrive\Počítač\Bakalárka\Matlab\utoky\Atack_5_1024.mat")

% uvodne 'konstanty'
dlzkaOkna = 100;

vystup = 1000;
dlzkaVstupu = length(H);
if vystup > dlzkaVstupu
    vystup = dlzkaVstupu -1;
end

pocetPredikovanych = vystup - dlzkaOkna;

zaciatok = 3500;
if zaciatok > dlzkaVstupu - vystup
    zaciatok = dlzkaVstupu - vystup;
end

% vykreslenie uvod
figure('Units', 'normalized', 'Position', [0.0, 0.05, 1, 0.84])
hold on;
title('2sigma tunel')
xlabel('ts')
ylabel('parameter')

% tvorba tunelu
u = H(zaciatok: zaciatok + dlzkaOkna + pocetPredikovanych - 1);
tunel = zeros(2, vystup - dlzkaOkna);

for t = 1: pocetPredikovanych
    radNaPredikciu = u(t: t + dlzkaOkna - 1);
    so = std(radNaPredikciu);
    sh = mean(radNaPredikciu);
    tunel(1, t) = sh + 2*so;
    tunel(2, t) = sh - 2*so;
end

% vykreslenie nasledujucich hodnot + tunel
time = linspace(1, dlzkaOkna + pocetPredikovanych, dlzkaOkna + pocetPredikovanych);
timeTunel = linspace(dlzkaOkna + 1, dlzkaOkna + pocetPredikovanych, pocetPredikovanych);

plot(time, u, 'blue', timeTunel, tunel, 'black', [dlzkaOkna dlzkaOkna], [min(tunel(2,:)) max(tunel(1,:))], 'black--')
legend('Parameter', 'tunel')

% horna hranica
centrHore = u(dlzkaOkna + 1: dlzkaOkna + pocetPredikovanych) - tunel(1,:);

plot(timeTunel, centrHore, 'blue', timeTunel, 0 * ones(1, pocetPredikovanych), 'black')
legend('Horná hranica')

% dolna hranica
centrDole = u(dlzkaOkna + 1: dlzkaOkna + pocetPredikovanych) - tunel(2,:);

plot(timeTunel, centrDole, 'blue', timeTunel, 0 * ones(1, pocetPredikovanych), 'black')
legend('Dolná hranica')

hold off;
