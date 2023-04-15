% Vytvorenie tunelu pomocou fourierovej transformácie. Pre 100 hodnôt procesu
% vytvoríme fourierovu transformáciu, vyberieme najpodstatnejšie píky a vytvoríme
% syntézu do ktorej dosadíme aj 10 nasledujúcich hodnôt procesu.
% Z týchto 10 hodnôt vytvoríme strdnú hodnotu a
% odchylku a kontrolujeme, či 101 hodnota procesu patrí do interválu
% I = <str.hodnota - 2*odchylka, str.hodnota + 2*odchylka> 
% Posúvame okno vždy o jedna a prepočítavame hodnoty nanovo.

function tunel = fourierova_transformacia(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup,metodaKoef,sigma)
    
    tunel = zeros(3, vystup - dlzkaOkna);

    for t = 1: vystup - dlzkaOkna
        uPovodny = data(zaciatok + t - 1: zaciatok + t + dlzkaOkna - 2);
        spektrum = fft(uPovodny);
        
        realne = real(spektrum);
        imaginarne = imag(spektrum);
        
        amplitudy = abs(spektrum);
        ampPol = amplitudy(1: dlzkaOkna/2+1);

        switch metodaKoef
            case 0
                % -- paretovo pravidlo --
                [~,index] = sort(ampPol,"descend");
                pocetFrekvecnii = 0;
            
                ampPolsum = sum(ampPol(2:end));
                sucetCa = 0;
                for ind = index
                    if ind ~= 1
                        sucetCa = sucetCa + ampPol(ind);
                        if (sucetCa/ampPolsum) < 0.800
                            pocetFrekvecnii = pocetFrekvecnii + 1;
                        end
                    end
                end
                
                pocetFrekvecnii = pocetFrekvecnii+1; % c0
                indexiPikov = index(1:pocetFrekvecnii);
                indexiPikov = indexiPikov-1;
            otherwise
                 % cez lokalne maxima
                [~, indexiPikov] = findpeaks(ampPol); % najde lokalne maxima a podla toho vyberie piky
                indexiPikov = indexiPikov - 1; % aby boli koeficienty od nuly
                indexiPikov(end+1) = 0; % aby sme tam nezabudli tu nulecku :)
        end

        funkcia = zeros(1,dlzkaOkna + pocetPredikovanych);
    
        for i = 1: dlzkaOkna + pocetPredikovanych
            ft = 0;
            % realne zlozky
            for k = indexiPikov
                if k == 0 || k == dlzkaOkna/2
                    ft = ft + (realne(k+1)/(dlzkaOkna))*cos((2*pi*(k)*(i-1))/dlzkaOkna);
                else
                    ft = ft + (realne(k+1)/(dlzkaOkna/2))*cos((2*pi*(k)*(i-1))/dlzkaOkna);
                end
            end    
            % imaginarne zlozky
            for k = indexiPikov
                ft = ft - (imaginarne(k+1)/(dlzkaOkna/2))*sin((2*pi*(k)*(i-1))/dlzkaOkna); 
            end 
       
            funkcia(i) = ft;
        end
    
        hodnotyDoTunela = funkcia(dlzkaOkna + 1: end);
        so = std(hodnotyDoTunela);
        sh = mean(hodnotyDoTunela);
        tunel(1, t) = sh + sigma*so;
        tunel(2, t) = sh - sigma*so;
    
        tunel(3,t) = hodnotyDoTunela(1);
    end
end
