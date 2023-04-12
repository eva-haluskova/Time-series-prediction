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

% vykreslenie
% 1 - tunel
% 2 - predikcia
% 3 - hh
% 4 - dh
% 5 - vyhladenie

% vyhladenie
% 0 - ziadne
% 1 - exponencialne
% 2 - modifikovane holtovo

okno = 1024;
utok = 1;
parameter = 'c';
metoda = 2;
vyhladenie = 0;

vykreslenie = 1;

dlzkaOkna = 100;
pocetPredikovanych = 10;
zaciatok = 9500;
vystup = 1000;

polynom = 3;
alfa = 0.05;
beta = 0.8;
kk = 0.8;

if utok == 1 && okno == 512
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_1_param_0512.mat";
    casUtoku = 10000;
elseif utok == 1 && okno == 1024
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_1_param_1024.mat";
    casUtoku = 10000;
elseif utok == 1 && okno == 2048
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_1_param_2048.mat";
    casUtoku = 10000;

elseif utok == 2 && okno == 512
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_2_param_0512.mat";
    casUtoku = 7830;
elseif utok == 2 && okno == 1024
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_2_param_1024.mat";
    casUtoku = 7830;
elseif utok == 2 && okno == 2048
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_2_param_2048.mat";
    casUtoku = 7830;

elseif utok == 3 && okno == 512
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_3_param_0512.mat";
    casUtoku = 5250;
elseif utok == 3 && okno == 1024
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_3_param_1024.mat";
    casUtoku = 5250;
elseif utok == 3 && okno == 2048
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_3_param_2048.mat";
    casUtoku = 5250;

elseif utok == 4 && okno == 512
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_4_param_0512.mat";
    casUtoku = 3050;
elseif utok == 4 && okno == 1024
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_4_param_1024.mat";
    casUtoku = 3050;
elseif utok == 4 && okno == 2048
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_4_param_2048.mat";
    casUtoku = 3050;

elseif utok == 6 && okno == 512
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_6_param_0512.mat";
    casUtoku = 7820;
elseif utok == 6 && okno == 1024
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_6_param_1024.mat";
    casUtoku = 7820;
elseif utok == 6 && okno == 2048
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_6_param_2048.mat";
    casUtoku = 7820;

elseif utok == 8 && okno == 512
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_8_param_0512.mat";
    casUtoku = 5260;
elseif utok == 8 && okno == 2048
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_8_param_1024.mat";
    casUtoku = 5260;
else
    nazov = "C:\Users\eva\OneDrive\Počítač\Bakalárka\Predikcne-tunely-matlab\utoky\Attack_8_param_2048.mat";
    casUtoku = 5260;
end

%zaciatok = casUtoku - vystup + 300;

% nacianie daneho utorku s danou sirkou okna    
load(nazov);
% podla vyberu vypoctu parametra sa do premennej data ulozi parameter
switch parameter
    case 'e'
        data = E;
    case 'so'
        data = s;
    case 'v'
        data = V;
    case 'k'
        data = K;
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

switch vyhladenie
    case 1
        povodneData = data;
        data = exponencialne_vyhladenie(data, alfa);
    case 2
        povodneData = data;
        data = modif_holtovo_vyhladenie(data, alfa, beta, kk);
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

klzavyPriemer = m;
casVocim = 0;

% na vykreslenie
%timeTunel = linspace(dlzkaOkna + 1, vystup, vystup - dlzkaOkna);
%timeVystup = linspace(1, vystup, vystup);
timeTunel = linspace(zaciatok+dlzkaOkna + 1, zaciatok+vystup, vystup - dlzkaOkna);
timeVystup = linspace(zaciatok, zaciatok+vystup, vystup);
uPovodny = data(zaciatok: zaciatok + vystup - 1);
% horna hranica
centrHore = uPovodny(dlzkaOkna + 1: dlzkaOkna + vystup - dlzkaOkna) - tunel(1,:);
% dolna hranica
centrDole = uPovodny(dlzkaOkna + 1: dlzkaOkna + vystup - dlzkaOkna) - tunel(2,:);
% pocet falosnych
pocetFalosnych = 0;

%{
for t = 2:casUtoku-zaciatok-dlzkaOkna         % vystup - dlzkaOkna
    if centrHore(t) > 0 && centrHore(t-1) <= 0
        pocetFalosnych = pocetFalosnych + 1;
    end
end
%}

% pre nazov ulozenia
switch metoda
    case 1
        met = '2sigmatunel';
    case 2
        met = 'polynom';
    case 3
        met = 'fourierka';
    case 4
        met = 'autoregresia';
    otherwise
        met = 'modifikovana_autoregresia';
end

switch parameter
    case 'e'
        par = 'entropia';
    case 'so'
        par = 'smerodajna_odchylka';
    case 'v'
        par = 'koef_variabilnosti';
    case 'k'
        par = 'sikmost';
    case 'sk'
        par = 'spicatost';
    case 'h'
        par = 'hurst';
    case 'c'
        par = 'autoregresia';
    case 'r'
        par = 'korelacny_koef';
    otherwise
        par = 'divergencia';
end 

% vykreslenie vytvoreneho tunelu
figure('Units', 'normalized', 'Position', [0.15, 0.15, 0.65, 0.65]);
hold on;
title(met)
xlabel('ts')
ylabel(par)

% vykreslenie + ulozenie
switch vykreslenie
    case 1
        plot(timeVystup, uPovodny,'blue', timeTunel, tunel(1,:),'black', timeTunel, tunel(2,:), 'black');
        plot([casUtoku casUtoku],[min(tunel(2,:)) max(tunel(1,:))], 'black--', 'LineWidth',2) % cas utorku
        %{
        annotation('arrow',[0.14+dlzkaOkna/(vystup*1.2)+0.0481 0.14+dlzkaOkna/(vystup*1.2)],[0.853276353276354 0.816239316239317]);
        annotation('textbox', [0.14+dlzkaOkna/(vystup*1.2) 0.846578347578348 0.14+dlzkaOkna/(vystup*1.2) 0.0584045584045584],...
            'String',{'začiatok tunelu'},'EdgeColor',[1 1 1]);

        annotation('arrow',[(0.14+(casUtoku-zaciatok)/(vystup*1.2)+0.0481)*0.95 (0.14+(casUtoku-zaciatok)/(vystup*1.2))*0.95],[0.853276353276354 0.816239316239317]);
        annotation('textbox', [0.14+(casUtoku-zaciatok)/(vystup*1.2) 0.846578347578348 0.14+(casUtoku-zaciatok)/(vystup*1.2) 0.0584045584045584],...
           'String',{'začiatok útoku'},'EdgeColor',[1 1 1]);
        %}
        plot([zaciatok+dlzkaOkna zaciatok+dlzkaOkna], [min(tunel(2,:)) max(tunel(1,:))], 'black--','LineWidth',2) % zaciatok tvorby tunela
        
        nazovFiguryPng = ['utok_',num2str(utok),'\tunel\tunel_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.png'];
        nazovFiguryFig = ['utok_',num2str(utok),'\tunel\tunel_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.fig'];
    case 2
        plot(timeTunel,tunel(3,:), 'green--')
        plot(timeVystup,uPovodny);

        nazovFiguryPng = ['utok_',num2str(utok),'\odhadnuty_proces\odhadnuty_proces_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.png'];
        nazovFiguryFig = ['utok_',num2str(utok),'\odhadnuty_proces\odhadnuty_proces_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.fig'];
    case 3
        plot(timeTunel, centrHore, 'blue', timeTunel, 0 * ones(1,vystup-dlzkaOkna), 'black')
        plot([casUtoku casUtoku],[min(centrHore) max(centrHore)], 'black--', 'LineWidth',2) % cas utorku
        %{
        annotation('arrow',[(0.14+(casUtoku-zaciatok)/(vystup*1.2)+0.0481)*0.95 (0.14+(casUtoku-zaciatok)/(vystup*1.2))*0.95],[0.853276353276354 0.816239316239317]);
        annotation('textbox', [0.14+(casUtoku-zaciatok)/(vystup*1.2) 0.846578347578348 0.14+(casUtoku-zaciatok)/(vystup*1.2) 0.0584045584045584],...
           'String',{'začiatok útoku'},'EdgeColor',[1 1 1]);
        %}
        nazovFiguryPng = ['utok_',num2str(utok),'\horna_hranica\horna_hranica_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.png'];
        nazovFiguryFig = ['utok_',num2str(utok),'\horna_hranica\horna_hranica_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.fig'];
    case 4
        plot(timeTunel, centrDole, 'blue', timeTunel, 0 * ones(1,vystup-dlzkaOkna), 'black')
        plot([casUtoku casUtoku],[min(centrDole) max(centrDole)], 'black--', 'LineWidth',2) % cas utorku
        %{
        annotation('arrow',[(0.14+(casUtoku-zaciatok)/(vystup*1.2)+0.0481)*0.95 (0.14+(casUtoku-zaciatok)/(vystup*1.2))*0.95],[0.853276353276354 0.816239316239317]);
        annotation('textbox', [0.14+(casUtoku-zaciatok)/(vystup*1.2) 0.846578347578348 0.14+(casUtoku-zaciatok)/(vystup*1.2) 0.0584045584045584],...
           'String',{'začiatok útoku'},'EdgeColor',[1 1 1]);
        %}

        nazovFiguryPng = ['utok_',num2str(utok),'\dolna_hranica\dolna_hranica_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.png'];
        nazovFiguryFig = ['utok_',num2str(utok),'\dolna_hranica\dolna_hranica_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.fig'];
    case 5
        n = length(povodneData);
        t = linspace(1,n,n);
        plot(t(zaciatok:zaciatok+vystup),povodneData(zaciatok:zaciatok+vystup),t(zaciatok:zaciatok+vystup),data(zaciatok:zaciatok+vystup))
end

% vypis uspesnosti

annotation('textbox',[0.00320512820512822 0.643874643874646 0.09375 0.291022792022796],...
    'String',{'počet falošných:',num2str(pocetFalosnych),'','čas voči m:',num2str(casVocim)},'FitBoxToText','off');
hold off;


% ulozenie
%saveas(gcf, nazovFiguryPng);
%saveas(gcf, nazovFiguryFig)

%{ 
% vykreslenie utoku original...
n = length(a);
t = linspace(1,n,n);
plot(t,a,t(okno+1:end),data,[casUtoku casUtoku],[min(a) max(a)], 'black--')
%}