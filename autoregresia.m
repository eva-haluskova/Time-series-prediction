% Vytvorenie tunelu pomocou autoregresie AR(1). Vypočítame autoregresny
% koeficient z prvych 100 hodnôt procesu a následne odhadneme dalších 10
% hodnôt. Z 10 odhadnutých hodnôt vytvoríme strdnú hodnotu a
% odchylku a kontrolujeme, či 101 hodnota procesu patrí do interválu
% I = <str.hodnota - 2*odchylka, str.hodnota + 2*odchylka> 
% Posúvame okno vždy o jedna a prepočítavame hodnoty nanovo.

function tunel = autoregresia(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup,sigma)
    
    tunel = zeros(3, vystup - dlzkaOkna);
    
    for t = 1:vystup-dlzkaOkna
        u = data(zaciatok + t - 1: zaciatok + t + dlzkaOkna - 2);
        f = u(2: dlzkaOkna);
        B = u(1: dlzkaOkna - 1);
        c = (f*B')*(B*B')^(-1);
    
        for prem = 1:pocetPredikovanych
            u(end + 1) = c*u(end);
        end
        
        hodnotyDoTunela = u(dlzkaOkna + 1: dlzkaOkna + pocetPredikovanych);
        so = std(hodnotyDoTunela);
        sh = mean(hodnotyDoTunela);
        tunel(1, t) = sh + sigma*so;
        tunel(2, t) = sh - sigma*so;
    
        tunel(3,t) = hodnotyDoTunela(1);
    end

end
