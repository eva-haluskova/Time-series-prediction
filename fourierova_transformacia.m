% Vytvorenie tunelu pomocou fourierovej transformácie. Pre 100 hodnôt procesu
% vytvoríme fourierovu transformáciu, vyberieme najpodstatnejšie píky a vytvoríme
% syntézu do ktorej dosadíme aj 10 nasledujúcich hodnôt procesu.
% Z týchto 10 hodnôt vytvoríme strdnú hodnotu a
% odchylku a kontrolujeme, či 101 hodnota procesu patrí do interválu
% I = <str.hodnota - 2*odchylka, str.hodnota + 2*odchylka> 
% Posúvame okno vždy o jedna a prepočítavame hodnoty nanovo.

function tunel = fourierova_transformacia(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup)
    
    dlzkaVstupu = length(data);
    if vystup > dlzkaVstupu
        vystup = dlzkaVstupu -1;
    end
    
    if zaciatok > dlzkaVstupu - vystup
        zaciatok = dlzkaVstupu - vystup;
    end

    tunel = zeros(2, vystup - dlzkaOkna);

    for t = 1: vystup - dlzkaOkna
        uPovodny = data(zaciatok + t - 1: zaciatok + t + dlzkaOkna - 2);
        spektrum = fft(uPovodny);
        
        realne = real(spektrum);
        imaginarne = imag(spektrum);
        
        amplitudy = abs(spektrum);
        ampPol = amplitudy(1: dlzkaOkna/2+1);
        [~, indexiPikov] = findpeaks(ampPol); % najde lokalne maxima a podla toho vyberie piky
    
        indexiPikov = indexiPikov - 1; % aby boli koeficienty od nuly
        indexiPikov(end+1) = 0; % aby sme tam nezabudli tu nulecku :)
        
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
        tunel(1, t) = sh + 2*so;
        tunel(2, t) = sh - 2*so;
    
        %odhadnutyProces(t) = hodnotyDoTunela(1);
    end
end
