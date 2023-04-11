% Vytvorenie tunelu pomocou autoregresie AR(1). Vypočítame autoregresny
% koeficient z prvych 100 hodnôt procesu a následne odhadneme dalších 10
% hodnôt. Z 10 odhadnutých hodnôt vytvoríme strdnú hodnotu a
% odchylku a kontrolujeme, či 101 hodnota procesu patrí do interválu
% I = <str.hodnota - 2*odchylka, str.hodnota + 2*odchylka> 
% Posúvame okno vždy o jedna a prepočítavame hodnoty nanovo.

clear
% nacitanie parametra
load("C:\Users\eva\OneDrive\Počítač\Bakalárka\Matlab\utoky\Atack_5_1024.mat")

% uvodne 'konstanty'
dlzkaOkna = 100;
pocetPredikovanych = 10;

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
title('Autoregresia')
xlabel('ts')
ylabel('parameter')

% tvorba autoregresie, predikcia, tunel

tunel = zeros(2, vystup - dlzkaOkna);

for t = 1:vystup-dlzkaOkna
    u = H(zaciatok + t - 1: zaciatok + t + dlzkaOkna - 2);
    f = u(2: dlzkaOkna);
    B = u(1: dlzkaOkna - 1);
    c = (f*B')*(B*B')^(-1);

    for prem = 1:pocetPredikovanych
        u(end + 1) = c*u(end);
    end
    
    hodnotyDoTunela = u(dlzkaOkna + 1: dlzkaOkna + pocetPredikovanych);
    so = std(hodnotyDoTunela);
    sh = mean(hodnotyDoTunela);
    tunel(1, t) = sh + 2*so;
    tunel(2, t) = sh - 2*so;

    odhadnutyProces(t) = hodnotyDoTunela(1);
end

% vykreslenie nasledujucich hodnot + tunel
timeTunel = linspace(dlzkaOkna + 1,vystup, vystup - dlzkaOkna);
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
%plot(timeVystup,uPovodny)

hold off;
