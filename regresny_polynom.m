% Vytvorenie tunelu pomocou regresného polynómu. Pre 100 hodnôt procesu
% vytvoríme regresný polynóm n-tého stupňa, do jeho predpisu dosadíme 10
% hodnôt. Z týchto 10 "predikovaných" hodnôt vytvoríme strdnú hodnotu a
% odchylku a kontrolujeme, či 101 hodnota procesu patrí do interválu
% I = <str.hodnota - 2*odchylka, str.hodnota + 2*odchylka> 
% Posúvame okno vždy o jedna a prepočítavame hodnoty nanovo.

clear
% nacitanie parametra
load("C:\Users\eva\OneDrive\Počítač\Bakalárka\Matlab\utoky\Atack_5_1024.mat")

% uvodne 'konstanty'
dlzkaOkna = 100;
pocetPredikovanych = 10;
polynomm = 3;

vystup = 1000;
dlzkaVstupu = length(H);
if vystup > dlzkaVstupu
    vystup = dlzkaVstupu -1;
end

zaciatok = 3500;
if zaciatok > dlzkaVstupu - vystup
    zaciatok = dlzkaVstupu - vystup;
end

% vykreslenie uvod
figure('Units', 'normalized', 'Position', [0.0, 0.05, 1, 0.84])
hold on;
title('Polynomická regresia')
xlabel('ts')
ylabel('parameter')

% tvorba regresie, predikcia, tunel
time = linspace(1, dlzkaOkna, dlzkaOkna);
timePredikovane = linspace(1, dlzkaOkna + pocetPredikovanych, dlzkaOkna + pocetPredikovanych);
tunel = zeros(2, vystup - dlzkaOkna);

for t = 1: vystup - dlzkaOkna
    u = H(zaciatok + t - 1: zaciatok + t + dlzkaOkna - 2);
    c = polyfit(time, u, polynomm);
    f = polyval(c, timePredikovane);

    hodnotyDoTunela = f(dlzkaOkna + 1:end);
    so = std(hodnotyDoTunela);
    sh = mean(hodnotyDoTunela);
    tunel(1, t) = sh + 2*so;
    tunel(2, t) = sh - 2*so;

    odhadnutyProces(t) = hodnotyDoTunela(1);
end

% vykreslenie nasledujucich hodnot + tunel
timeTunel = linspace(dlzkaOkna + 1, vystup, vystup - dlzkaOkna);
timeVystup = linspace(1, vystup, vystup);
uPovodny = H(zaciatok: zaciatok + vystup - 1);

plot(timeVystup, uPovodny,'blue', timeTunel, tunel, 'black',[dlzkaOkna dlzkaOkna], [min(tunel(2,:)) max(tunel(1,:))], 'black--');
legend('Parameter', 'tunel')

% horna hranica
centrHore = uPovodny(dlzkaOkna + 1: dlzkaOkna + vystup - dlzkaOkna) - tunel(1,:);

plot(timeTunel, centrHore, 'blue', timeTunel, 0 * ones(1,vystup-dlzkaOkna), 'black')
legend('Horná hranica')

% dolna hranica
centrDole = uPovodny(dlzkaOkna + 1: dlzkaOkna + vystup - dlzkaOkna) - tunel(2,:);

plot(timeTunel, centrDole, 'blue', timeTunel, 0 * ones(1,vystup-dlzkaOkna), 'black')
legend('Dolná hranica')

% odhadnuty proces
plot(timeTunel,odhadnutyProces, 'green--')
%plot(timeVystup,uPovodny);

hold off;
