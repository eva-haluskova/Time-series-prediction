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

%utociky = [1,2,3,8,4,6];
%okna = [512,1024,2048];
metody = [1,2,3,4,5];
parametricky = ["c","d","e","h","v","r","k","so","sk"];
vyhladenicka = [0,1,2];

utociky = 6;
okna = 1024;
%metody = 1;

%vyhladenicka = 0;
%parametricky = "v";

% 2,2.5,3,3.5,4
sigmy = [2,2.5,3,4];

polynom = 2;
kalibracia = 400;
% 0 - pareto, 1 - peaks
fourierka_koeficienty = 0;
% <0,1>
alfa = 0.05;
beta = 0.8;
kk = 0.5;

vykreslenie = 1;
dlzkaOkna = 100;
pocetPredikovanych = 10;
zaciatok = 1;
vystup = 100000;


% cykli cykli
for utocik = utociky

    for okenicko = okna
        
        vysledkyFalosne = 0;
        vysledkyTs = 0;
        vysledkyRozpoznanie = 0;

        pocMet = 1;
        pocPar = 1;

        for vyhladenicko = vyhladenicka

            for metodka = metody

                for sigma = sigmy
                    
                    for paramko = parametricky
                        


                        % cykli cykli
                        okno = okenicko;
                        parameter = paramko;
                        metoda = metodka;
                        vyhladenie = vyhladenicko;
                        utok = utocik;
                        
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
                        
                        % odpocitavam pretoze parameter mi zacina az za tym oknom.
                        casUtoku = casUtoku - okno;
                        casRozpoznaniaM = casRozpoznaniaM - okno;
                        
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
                                    data = a(i:okno+i);
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
                        
                        dlzkaParam = length(data); % dlzka parametra
                        N = length(a); % dlzka utoku, nie dlzka parametra ani tunela...
                        
                        % kontrola spravnej dlzky
                        % !!!!!
                        if vystup > dlzkaParam
                            vystup = dlzkaParam - 1;
                        end
                        
                        if zaciatok > (dlzkaParam-vystup)
                            zaciatok = dlzkaParam-vystup;
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
                                tunel = dve_sigmy(data,dlzkaOkna,zaciatok,vystup,sigma);
                            case 2
                                tunel = regresny_polynom(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup,polynom,sigma);
                            case 3
                                tunel = fourierova_transformacia(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup,fourierka_koeficienty,sigma);
                            case 4
                                tunel = autoregresia(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup,sigma);
                            otherwise
                                tunel = modifikovana_autoregresia(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup,kalibracia,sigma);
                        end
                        
                        % na vykreslenie
                        
                        timeTunel = linspace(zaciatok+dlzkaOkna + 1, zaciatok+vystup, vystup - dlzkaOkna);
                        timeVystup = linspace(zaciatok, zaciatok+vystup, vystup);
                        uPovodny = data(zaciatok: zaciatok + vystup - 1);
                        if metoda == 5
                             timeTunel = linspace(zaciatok+kalibracia +dlzkaOkna+ 1, zaciatok+vystup, vystup - kalibracia-dlzkaOkna);
                        end
                        % horna hranica
                        if metoda == 5 
                            centrHore = uPovodny(kalibracia +dlzkaOkna+ 1: kalibracia+ vystup- kalibracia) - tunel(1,:);
                        else
                            centrHore = uPovodny(dlzkaOkna + 1: dlzkaOkna + vystup - dlzkaOkna) - tunel(1,:);
                        end
                        % dolna hranica
                        if metoda == 5 
                            centrDole = uPovodny(kalibracia +dlzkaOkna+ 1: kalibracia+ vystup- kalibracia) - tunel(2,:);
                        else
                            centrDole = uPovodny(dlzkaOkna + 1: dlzkaOkna + vystup - dlzkaOkna) - tunel(2,:);
                        end
                        
                        % pocet falosnych Pocet
                        pocetFalosnych = 0;
                        
                        if metoda == 5
                            for t = 2:casUtoku-(zaciatok+kalibracia+dlzkaOkna)
                                if centrHore(t) > 0 && centrHore(t-1) <= 0
                                    pocetFalosnych = pocetFalosnych + 1;
                                end
                                if centrDole(t) < 0 && centrDole(t-1) >= 0
                                    pocetFalosnych = pocetFalosnych + 1;
                                end
                            end
                        else
                            for t = 2:casUtoku-(zaciatok+dlzkaOkna)
                                if centrHore(t) > 0 && centrHore(t-1) <= 0
                                    pocetFalosnych = pocetFalosnych + 1;
                                end
                                if centrDole(t) < 0 && centrDole(t-1) >= 0
                                    pocetFalosnych = pocetFalosnych + 1;
                                end
                            end
                        end
                        
                        % pocet falosnych Sloty
                        pocetFalosnychSlotov = 0;
                        if metoda == 5
                            for t = 2:casUtoku-(zaciatok+kalibracia+dlzkaOkna)
                                if centrHore(t) > 0
                                    pocetFalosnychSlotov = pocetFalosnychSlotov + 1;            
                                end
                                if centrDole(t) < 0
                                    pocetFalosnychSlotov = pocetFalosnychSlotov + 1;
                                end
                            end
                        else
                            for t = 2:casUtoku-(zaciatok+dlzkaOkna)
                                if centrHore(t) > 0
                                    pocetFalosnychSlotov = pocetFalosnychSlotov + 1;
                                end
                                if centrDole(t) < 0
                                    pocetFalosnychSlotov = pocetFalosnychSlotov + 1;
                                end
                            end
                        end
                        
                        % cas rozpoznania voci klzavemu priemeru
                        casHore = 1;
                        casDole = 1;
                        if metoda == 5
                            t = casUtoku-(zaciatok+kalibracia+dlzkaOkna);
                        else
                            t = casUtoku-(zaciatok+dlzkaOkna);
                        end    
                        

                        while centrHore(t) > 0 && centrHore(t-1) > 0
                            casHore = casHore + 1;
                            t = t+1;
                        end
                      

                        while centrHore(t) < 0
                            casHore = casHore + 1;
                            if t < length(centrHore)
                                t = t + 1;
                            else
                                break;
                            end
                        end
                        
                        if metoda == 5
                            t = casUtoku-(zaciatok+kalibracia+dlzkaOkna)+1;
                        else
                            t = casUtoku-(zaciatok+dlzkaOkna)+1;
                        end 
                        
                        while centrDole(t) < 0 && centrDole(t-1) < 0
                            casDole = casDole + 1;
                            t = t + 1;
                        end
                        
                        while centrDole(t) > 0
                            casDole = casDole + 1;
                            if t < length(centrDole)
                                t = t + 1;
                            else
                                break;
                            end
                        end
                        %cas = min(casDole,casHore);
                        %casVociM = (casRozpoznaniaM-casUtoku)/cas;   
    
                        % cas rozpoznania tunelom od zaciatku utoku
                        cas = min(casDole,casHore);
                        casVociM = cas;
    
                     
                        
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
                                met = 'modifikovanaautoregresia';
                        end
                        
                        switch parameter
                            case 'e'
                                par = 'entropia';
                            case 'so'
                                par = 'smerodajnaodchylka';
                            case 'v'
                                par = 'koefvariabilnosti';
                            case 'k'
                                par = 'sikmost';
                            case 'sk'
                                par = 'spicatost';
                            case 'h'
                                par = 'hurst';
                            case 'c'
                                par = 'autoregresia';
                            case 'r'
                                par = 'korelacnykoef';
                            otherwise
                                par = 'divergencia';
                        end 
                        
                        switch vyhladenie
                            case 0
                                vyhl = 'bez';
                            case 1
                                vyhl = 'exponencialne';
                            case 2
                                vyhl = 'holtovo';
                        end
                        
                        % vykreslenie vytvoreneho tunelu
                        figure('Units', 'normalized', 'Position', [0.15, 0.15, 0.65, 0.65]);
                        hold on;
                        switch vykreslenie
                            case 1
                                title(['Útok\_',num2str(utok),'\_cw\_',num2str(okno),'\_tunel\_',met])
                            case 2
                                title(['Útok\_',num2str(utok),'\_cw\_',num2str(okno),'\_odhadnuty\_proces\_',met])
                            case 3
                                title(['Útok\_',num2str(utok),'\_cw\_',num2str(okno),'\_horna\_hranica\_',met])
                            case 4
                                title(['Útok\_',num2str(utok),'\_cw\_',num2str(okno),'\_dolna\_hranica\_',met])
                            case 5
                                title(['Útok\_',num2str(utok),'\_cw\_',num2str(okno),'\_vyhladenie\_',met])
                        end
                        xlabel('ts')
                        ylabel(par)
                        
                        switch okno
                            case 512
                                if metoda == 5
                                    konstO = 1500;
                                    konstM = 500;
                                else
                                    konstO = 1000;
                                    konstM = 500;
                                end
                            case 1024
                                if metoda == 5
                                    konstO = 2000;
                                    konstM = 500;
                                else
                                    konstO = 1500;
                                    konstM = 500;
                                end
                                if utok == 4
                                    konstO = 1500;
                                    konstM = 200;
                                end
                                if utok == 3
                                    konstO = 1500;
                                    konstM = 200;
                                end
                                if utok == 8
                                    konstO = 2000;
                                    konstM = 300;
                                end
                                if utok == 8 && metoda == 5
                                    konstO = 2500;
                                    konstM = -50;
                                end
                            case 2048
                                if metoda == 5
                                    konstO = 2500;
                                    konstM = 500;
                                else
                                    konstO = 2000;
                                    konstM = 500;  
                                end
                                if utok == 4
                                    konstO = 500;
                                    konstM = -20;
                                end
                                if utok == 8
                                    konstO = 1000;
                                    konstM = 0; 
                                end
                        end
                        
                        
                        % vykreslenie + ulozenie
                        switch vykreslenie
                            case 1 % tunel
                                if metoda == 5
                                    plot(timeVystup(casUtoku-konstO:casRozpoznaniaM+konstM), uPovodny(casUtoku-konstO:casRozpoznaniaM+konstM ),'blue')
                                    plot(timeTunel(casUtoku-konstO:casRozpoznaniaM+konstM ), tunel(1,(casUtoku-konstO:casRozpoznaniaM+konstM )),'black')
                                    plot(timeTunel(casUtoku-konstO:casRozpoznaniaM+konstM ), tunel(2,(casUtoku-konstO:casRozpoznaniaM+konstM )), 'black');
                        
                                    plot([casUtoku casUtoku],[min(tunel(2,:)) max(tunel(1,:))], 'black--', 'LineWidth',2) % cas utoku
                                    plot([casUtoku-konstO+dlzkaOkna+kalibracia casUtoku-konstO+dlzkaOkna+kalibracia], [min(tunel(2,:)) max(tunel(1,:))], 'black--','LineWidth',2) % zaciatok tvorby tunela
                                    plot([casRozpoznaniaM casRozpoznaniaM],[min(tunel(2,:)) max(tunel(1,:))], 'black--', 'LineWidth',2) % cas rozpozania klzaceho priemeru
                        
                                    anArrow = annotation('textarrow') ;
                                    anArrow.Parent = gca;
                                    anArrow.Position = [casUtoku-100, max(tunel(1,:)), 80, 0] ;
                                    anArrow.String = 'zaciatok utoku ';
                                    anArrow.Color = 'black';
                                else
                                    plot(timeVystup(casUtoku-konstO:casRozpoznaniaM+konstM), uPovodny(casUtoku-konstO:casRozpoznaniaM+konstM ),'blue')
                                    plot(timeTunel(casUtoku-konstO:casRozpoznaniaM+konstM ), tunel(1,(casUtoku-konstO:casRozpoznaniaM+konstM )),'black')
                                    plot(timeTunel(casUtoku-konstO:casRozpoznaniaM+konstM ), tunel(2,(casUtoku-konstO:casRozpoznaniaM+konstM )), 'black');
                        
                                    plot([casUtoku casUtoku],[min(tunel(2,:)) max(tunel(1,:))], 'black--', 'LineWidth',2) % cas utoku
                                    plot([casUtoku-konstO+dlzkaOkna casUtoku-konstO+dlzkaOkna], [min(tunel(2,:)) max(tunel(1,:))], 'black--','LineWidth',2) % zaciatok tvorby tunela
                                    plot([casRozpoznaniaM casRozpoznaniaM],[min(tunel(2,:)) max(tunel(1,:))], 'black--', 'LineWidth',2) % cas rozpozania klzaceho priemeru
                              
                                    anArrow = annotation('textarrow') ;
                                    anArrow.Parent = gca;
                                    if max(tunel(1,:)) >= 2 
                                        pos = 2;
                                    else
                                        pos = max(tunel(1,:));
                                    end
                                    anArrow.Position = [casUtoku-100, pos, 80, 0] ;
                                    anArrow.String = 'zaciatok utoku ';
                                    anArrow.Color = 'black';
                                end
                                annotation('textbox',...
                                    [0.137820512820513 0.833757834757836 0.133413461538462 0.0584045584045584],...
                                    'String',{'začiatok tunelu'},...
                                    'EdgeColor',[1 1 1]);
                        
                        
                                nazovFiguryPng = ['utok_',num2str(utok),'\tunel_',num2str(sigma),'_sigma\',vyhl,'\',num2str(okno),'\',met,'\','tunel_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'','.png'];
                                nazovFiguryFig = ['utok_',num2str(utok),'\tunel_',num2str(sigma),'_sigma\',vyhl,'\',num2str(okno),'\',met,'\','tunel_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'','.fig'];
                            
                              
                            case 2 % odhadnuty proces
                                if metoda == 5
                                    plot(timeVystup(kalibracia+1:end),tunel(3,:), 'red--','LineWidth',2)
                                    plot(timeVystup,uPovodny,'black','LineWidth',2);
                                    plot([zaciatok+kalibracia zaciatok+kalibracia], [min(tunel(3,:)) max(tunel(3,:))], 'black--','LineWidth',2) % zaciatok tvorby tunela
                               
                                else    
                                    plot(timeTunel,tunel(3,:), 'red--')
                                    plot(timeVystup,uPovodny,'black');
                                    legend("Pôvodný proces","Odhadnutý proces")
                                    plot([zaciatok+dlzkaOkna zaciatok+dlzkaOkna], [min(tunel(3,:)) max(tunel(3,:))], 'black--','LineWidth',2) % zaciatok tvorby tunela
                                end
                        
                                    annotation('textbox',...
                                [0.137820512820513 0.833757834757836 0.133413461538462 0.0584045584045584],...
                                'String',{'začiatok predikovanych hodnôt'},...
                                'EdgeColor',[1 1 1]);
                            
                            
                                nazovFiguryPng = ['utok_',num2str(utok),'\odhadnuty_proces\odhadnuty_proces_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.png'];
                                nazovFiguryFig = ['utok_',num2str(utok),'\odhadnuty_proces\odhadnuty_proces_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.fig'];
                            
                            case 3 % horna hranica
                                if metoda == 5
                                    plot(timeVystup(kalibracia+dlzkaOkna+1:end), centrHore, 'blue', timeVystup, 0 * ones(1,vystup), 'black')
                                    plot([casUtoku casUtoku],[min(centrHore) max(centrHore)], 'black--', 'LineWidth',2) % cas utoku
                                    plot([casRozpoznaniaM casRozpoznaniaM],[min(centrHore) max(centrHore)], 'black--', 'LineWidth',2) % cas rozpozania klzaceho priemeru
                                else
                                    plot(timeTunel, centrHore, 'blue', timeVystup, 0 * ones(1,vystup), 'black')
                                    plot([casUtoku casUtoku],[min(centrHore) max(centrHore)], 'black--', 'LineWidth',2) % cas utoku
                                    plot([casRozpoznaniaM casRozpoznaniaM],[min(centrHore) max(centrHore)], 'black--', 'LineWidth',2) % cas rozpozania klzaceho priemeru
                                end   
                                nazovFiguryPng = ['utok_',num2str(utok),'\horna_hranica\horna_hranica_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.png'];
                                nazovFiguryFig = ['utok_',num2str(utok),'\horna_hranica\horna_hranica_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.fig'];
                            
                            case 4 % dolna hranica
                                if metoda == 5
                                    plot(timeVystup(kalibracia+dlzkaOkna+1:end), centrDole, 'blue', timeVystup, 0 * ones(1,vystup), 'black')
                                    plot([casUtoku casUtoku],[min(centrHore) max(centrHore)], 'black--', 'LineWidth',2) % cas utoku
                                    plot([casRozpoznaniaM casRozpoznaniaM],[min(centrHore) max(centrHore)], 'black--', 'LineWidth',2) % cas rozpozania klzaceho priemeru
                               
                                else
                                    plot(timeTunel, centrDole, 'blue', timeVystup, 0 * ones(1,vystup), 'black')
                                    plot([casUtoku casUtoku],[min(centrDole) max(centrDole)], 'black--', 'LineWidth',2) % cas utoku
                                    plot([casRozpoznaniaM casRozpoznaniaM],[min(centrHore) max(centrHore)], 'black--', 'LineWidth',2) % cas rozpozania klzaceho priemeru
                              
                                end
                                nazovFiguryPng = ['utok_',num2str(utok),'\dolna_hranica\dolna_hranica_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.png'];
                                nazovFiguryFig = ['utok_',num2str(utok),'\dolna_hranica\dolna_hranica_utok_',num2str(utok),'_',num2str(okno),'_',par,'_',met,'.fig'];
                            
                            case 5 % vyhladenie
                                n = length(povodneData);
                                t = linspace(1,n,n);
                                plot(t(zaciatok:zaciatok+vystup),povodneData(zaciatok:zaciatok+vystup),'blue')
                                plot(t(zaciatok:zaciatok+vystup),data(zaciatok:zaciatok+vystup),'red')
                        
                        end
                        
                        % vypis uspesnosti
                        annotation('textbox',[0.00560897435897439 0.67948717948718 0.0929487179487179 0.313814814814833],...
                            'String',{'Počet falošných:',[num2str(pocetFalosnych),' krát'],[num2str(pocetFalosnychSlotov),' ts'],'Rozp. od začiatku útoku',[num2str(casVociM),' ts']},'FitBoxToText','off');
                        
                        %xlim([zaciatok zaciatok+vystup])
                        xlim([casUtoku-konstO casRozpoznaniaM+konstM])
                        %set(gcf, 'WindowState', 'maximized')
                        hold off;
                        
                        
                        % ulozenie
                        saveas(gcf, nazovFiguryPng)
                        saveas(gcf, nazovFiguryFig)
        
                        close(gcf)
                        
                        % ZMENA

                        vysledkyFalosne(pocMet,pocPar) = pocetFalosnych;
                        vysledkyTs(pocMet,pocPar) = pocetFalosnychSlotov;
                        vysledkyRozpoznanie(pocMet,pocPar) = casVociM;
        
                        
                        pocPar = pocPar + 1;
                    end
                                        
                end               
                % ZMENA
                nazovSuboru = ['matSubory\utok_',num2str(utok),'_',num2str(sigma),'_sigma_fal_23.mat'];
                save(nazovSuboru,"vysledkyFalosne");
                nazovSuboru = ['matSubory\utok_',num2str(utok),'_',num2str(sigma),'_sigma_ts_23.mat'];
                save(nazovSuboru,"vysledkyTs")
                nazovSuboru = ['matSubory\utok_',num2str(utok),'_',num2str(sigma),'_sigma_roz_23.mat'];
               
                save(nazovSuboru,"vysledkyRozpoznanie");
                

            end
            pocMet = pocMet + 1;
        end
    end
end