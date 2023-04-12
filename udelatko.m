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

% volitelne parametre
okno = 2048;
utok = 1;
parameter = 'sk';
metoda = 1;
vyhladenie = 0;

vykreslenie = 1;

dlzkaOkna = 100;
pocetPredikovanych = 10;
zaciatok = 9500;
vystup = 1000;

polynom = 2;
kalibracia = 400;
% 0 - pareto, 1 - peaks
fourierka_koeficienty = 1;
% <0,1>
alfa = 0.95;
beta = 0.8;
kk = 0.8;

% nacianie daneho utorku s danou sirkou okna  
if okno == 512
    nazov = "utoky\Attack_"+num2str(utok)+"_param_0"+num2str(okno)+".mat";
else
    nazov = "utoky\Attack_"+num2str(utok)+"_param_"+num2str(okno)+".mat";
end

load(nazov);

% cas zaciatku utoku + cas detegcie klzavim priemerom
if utok == 1 && okno == 512
    casUtoku = 10000;
    casRozpoznaniaM = 10555;
elseif utok == 1 && okno == 1024
    casUtoku = 10000;
    casRozpoznaniaM = 11000;
elseif utok == 1 && okno == 2048
    casUtoku = 10000;
    casRozpoznaniaM = 12032;

elseif utok == 2 && okno == 512
    casUtoku = 7823;
    casRozpoznaniaM = 9716;
elseif utok == 2 && okno == 1024
    casUtoku = 7823;
    casRozpoznaniaM = 9716;
elseif utok == 2 && okno == 2048
    casUtoku = 7823;
    casRozpoznaniaM = 9852;

elseif utok == 3 && okno == 512
    casUtoku = 5244;
    casRozpoznaniaM = 5732;
elseif utok == 3 && okno == 1024
    casUtoku = 5244;
    casRozpoznaniaM = 6246;
elseif utok == 3 && okno == 2048
    casUtoku = 5244;
    casRozpoznaniaM = 6246;

elseif utok == 4 && okno == 512
    casUtoku = 3060;
    casRozpoznaniaM = 3570; 
elseif utok == 4 && okno == 1024
    casUtoku = 3060;
    casRozpoznaniaM = 4080;
elseif utok == 4 && okno == 2048
    casUtoku = 3060;
    casRozpoznaniaM = 5000;

elseif utok == 6 && okno == 512
    casUtoku = 7830;
    casRozpoznaniaM = 9231;
elseif utok == 6 && okno == 1024
    casUtoku = 7830;
    casRozpoznaniaM = 9754;
elseif utok == 6 && okno == 2048
    casUtoku = 7830;
    casRozpoznaniaM = 10150;

elseif utok == 8 && okno == 512
    casUtoku = 5261;
    casRozpoznaniaM = 5802;
elseif utok == 8 && okno == 1024
    casUtoku = 5261;
    casRozpoznaniaM = 6314;
else
    casUtoku = 5261; 
    casRozpoznaniaM = 7345;
end  

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
        for i=1:length(a)-okno
            data = a(i:okno-1+i);
            hu(i) = Hurst(data,0,1,0);
        end
        data = hu;
    case 'c'
        data = c;
    case 'r'
        data = ro;
    otherwise
        data = divg;
end 

N = length(a); % dlzka utoku, nie dlzka parametra ani tunela...

% kontrola spravnej dlzky

if vystup > N - okno
    vystup = N - okno - 1;
end

if zaciatok > (N - vystup - okno)
    zaciatok = N - vystup - okno;
end

% vyber vyhladenia
switch vyhladenie
    case 1
        povodneData = data;
        data = exponencialne_vyhladenie(data, alfa);
    case 2
        povodneData = data;
        data = modif_holtovo_vyhladenie(data, alfa, beta, kk);
end

% vyber metody predickie
switch metoda
    case 1
        tunel = dve_sigmy(data,dlzkaOkna,zaciatok,vystup);
    case 2
        tunel = regresny_polynom(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup,polynom);
    case 3
        tunel = fourierova_transformacia(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup,fourierka_koeficienty);
    case 4
        tunel = autoregresia(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup);
    otherwise
        tunel = modifikovana_autoregresia(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup,kalibracia);
end

% na vykreslenie

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

% cas rozpoznania voci klzavemu priemeru
casVociM= 0;

% pre nazov ulozenia a vykreslenie
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
    case 1 % tunel
        plot(timeVystup, uPovodny,'blue', timeTunel, tunel(1,:),'black', timeTunel, tunel(2,:), 'black');
        plot([casUtoku-okno casUtoku-okno],[min(tunel(2,:)) max(tunel(1,:))], 'red--', 'LineWidth',2) % cas utoku
        plot([zaciatok+dlzkaOkna zaciatok+dlzkaOkna], [min(tunel(2,:)) max(tunel(1,:))], 'black--','LineWidth',2) % zaciatok tvorby tunela

        
        %annotation('arrow',[(casUtoku-zaciatok/vystup)+0.05 (casUtoku/N)],[0.85 0.75]);
        %{
        annotation('arrow',[0.14+dlzkaOkna/(vystup*1.2)+0.0481 0.14+dlzkaOkna/(vystup*1.2)],[0.853276353276354 0.816239316239317]);
        annotation('textbox', [0.14+dlzkaOkna/(vystup*1.2) 0.846578347578348 0.14+dlzkaOkna/(vystup*1.2) 0.0584045584045584],...
            'String',{'začiatok tunelu'},'EdgeColor',[1 1 1]);

        annotation('arrow',[(0.14+(casUtoku-zaciatok)/(vystup*1.2)+0.0481)*0.95 (0.14+(casUtoku-zaciatok)/(vystup*1.2))*0.95],[0.853276353276354 0.816239316239317]);
        annotation('textbox', [0.14+(casUtoku-zaciatok)/(vystup*1.2) 0.846578347578348 0.14+(casUtoku-zaciatok)/(vystup*1.2) 0.0584045584045584],...
           'String',{'začiatok útoku'},'EdgeColor',[1 1 1]);
        %}
       
        nazovFiguryPng = ['utok_',num2str(utok),'\tunel\tunel_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.png'];
        nazovFiguryFig = ['utok_',num2str(utok),'\tunel\tunel_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.fig'];
    
    case 2 % odhadnuty proces
        plot(timeTunel,tunel(3,:), 'green--')
        plot(timeVystup,uPovodny);

        nazovFiguryPng = ['utok_',num2str(utok),'\odhadnuty_proces\odhadnuty_proces_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.png'];
        nazovFiguryFig = ['utok_',num2str(utok),'\odhadnuty_proces\odhadnuty_proces_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.fig'];
    
    case 3 % horna hranica
        plot(timeTunel, centrHore, 'blue', timeTunel, 0 * ones(1,vystup-dlzkaOkna), 'black')
        plot([casUtoku-okno casUtoku-okno],[min(centrHore) max(centrHore)], 'black--', 'LineWidth',2) % cas utorku
        %{
        annotation('arrow',[(0.14+(casUtoku-zaciatok)/(vystup*1.2)+0.0481)*0.95 (0.14+(casUtoku-zaciatok)/(vystup*1.2))*0.95],[0.853276353276354 0.816239316239317]);
        annotation('textbox', [0.14+(casUtoku-zaciatok)/(vystup*1.2) 0.846578347578348 0.14+(casUtoku-zaciatok)/(vystup*1.2) 0.0584045584045584],...
           'String',{'začiatok útoku'},'EdgeColor',[1 1 1]);
        %}
        nazovFiguryPng = ['utok_',num2str(utok),'\horna_hranica\horna_hranica_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.png'];
        nazovFiguryFig = ['utok_',num2str(utok),'\horna_hranica\horna_hranica_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.fig'];
    
    case 4 % dolna hranica
        plot(timeTunel, centrDole, 'blue', timeTunel, 0 * ones(1,vystup-dlzkaOkna), 'black')
        plot([casUtoku-okno casUtoku-okno],[min(centrDole) max(centrDole)], 'black--', 'LineWidth',2) % cas utorku
        %{
        annotation('arrow',[(0.14+(casUtoku-zaciatok)/(vystup*1.2)+0.0481)*0.95 (0.14+(casUtoku-zaciatok)/(vystup*1.2))*0.95],[0.853276353276354 0.816239316239317]);
        annotation('textbox', [0.14+(casUtoku-zaciatok)/(vystup*1.2) 0.846578347578348 0.14+(casUtoku-zaciatok)/(vystup*1.2) 0.0584045584045584],...
           'String',{'začiatok útoku'},'EdgeColor',[1 1 1]);
        %}

        nazovFiguryPng = ['utok_',num2str(utok),'\dolna_hranica\dolna_hranica_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.png'];
        nazovFiguryFig = ['utok_',num2str(utok),'\dolna_hranica\dolna_hranica_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.fig'];
    
    case 5 % vyhladenie
        n = length(povodneData);
        t = linspace(1,n,n);
        plot(t(zaciatok:zaciatok+vystup),povodneData(zaciatok:zaciatok+vystup),t(zaciatok:zaciatok+vystup),data(zaciatok:zaciatok+vystup))
end

% vypis uspesnosti
annotation('textbox',[0.00641025641025642 0.633903133903137 0.09375 0.291022792022797],...
    'String',{'počet falošných:',num2str(pocetFalosnych),'...%','čas voči m:',num2str(casVociM)},'FitBoxToText','off');
xlim([zaciatok zaciatok+vystup])
hold off;


% ulozenie
%saveas(gcf, nazovFiguryPng);
%saveas(gcf, nazovFiguryFig)
length(a)


% vykreslenie utoku original...
%{
n = length(a);
t = linspace(1,n,n);
hold on;
plot(t,a,'blue')
plot(t(okno+1:end),m,'red','LineWidth',2)
legend('48')
hold off;
%}