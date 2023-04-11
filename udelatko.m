clear

% vyber sirky okna
% 512, 1024, 2048

% vyber utoku
% 1,2,3,4,6,8

% vyber parametra
% e - entropia
% h - hurstov exponent
% k - sikmost
% d - divergencia
% r - korelacny koeficient
% m - klzavy priemer
% so - smerodajna odchylka
% sk - spicatost
% v - koeficient variabilnosti
% c - autoregresia

% vyber metody tunelu
% 1 - 2sigma tunel
% 2 - regresny polynom
% 3 - forurierova transformacia
% 4 - ar(1)
% 5 - ar(m,n)


okno = 512;
utok = 4;
parameter = 'so';
metoda = 4;

dlzkaOkna = 100;
pocetPredikovanych = 10;
zaciatok = 1;
vystup = 1000;

polynom = 3;


if utok == 1 && okno == 512
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_1_param_0512.mat";
elseif utok == 1 && okno == 1024
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_1_param_1024.mat";
elseif utok == 1 && okno == 2048
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_1_param_2048.mat";

elseif utok == 2 && okno == 512
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_2_param_0512.mat";
elseif utok == 2 && okno == 1024
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_2_param_1024.mat";
elseif utok == 2 && okno == 5120482
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_2_param_2048.mat";

elseif utok == 3 && okno == 512
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_3_param_0512.mat";
elseif utok == 3 && okno == 1024
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_3_param_1024.mat";
elseif utok == 3 && okno == 2048
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_3_param_2048.mat";

elseif utok == 4 && okno == 512
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_4_param_0512.mat";
elseif utok == 4 && okno == 1024
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_4_param_1024.mat";
elseif utok == 4 && okno == 2048
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_4_param_2048.mat";

elseif utok == 6 && okno == 512
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_6_param_0512.mat";
elseif utok == 6 && okno == 1024
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_6_param_1024.mat";
elseif utok == 6 && okno == 2048
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_6_param_2048.mat";

elseif utok == 8 && okno == 512
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_8_param_0512.mat";
elseif utok == 8 && okno == 2048
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_8_param_1024.mat";
else
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_8_param_2048.mat";
end


% nacianie daneho utorku s danou sirkou okna    
load(nazov);
% podla vyberu vypoctu parametra sa do premennej data ulozi parameter
switch parameter
    case 'e'
        data = E;
    case 'm'
        data = m;
    case 'so'
        data = s;
    case 'v'
        data = V;
    case 'k'
        data = k;
    case 'sk'
        data = Skw;
    case 'h'
        data = H;
    case 'c'
        data = c;
    case 'r'
        data = ro;
    otherwise
        data = divg;
end 

switch metoda
    case 1
        tunel = dve_sigmy(data,dlzkaOkna,zaciatok,vystup);
    case 2
        tunel = regresny_polynom(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup,polynom);
    case 3
        tunel = fourierova_transformacia(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup);
    case 4
        tunel = autoregresia(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup);
    otherwise
        tunel = autoregresia();
end

% vykreslenie vytvoreneho tunelu
figure('Units', 'normalized', 'Position', [0.15, 0.15, 0.65, 0.65]);
hold on;
title('Polynomická regresia')
xlabel('ts')
ylabel('parameter')

timeTunel = linspace(dlzkaOkna + 1, vystup, vystup - dlzkaOkna);
timeVystup = linspace(1, vystup, vystup);
uPovodny = data(zaciatok: zaciatok + vystup - 1);

plot(timeVystup, uPovodny,'blue', timeTunel, tunel, 'black',[dlzkaOkna dlzkaOkna], [min(tunel(2,:)) max(tunel(1,:))], 'black--');
legend('Parameter', 'tunel')

%{
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
%}

hold off;