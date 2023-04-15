% Vytvorenie tunelu pomocou modifikovanej autoregresie

function tunel = modifikovana_autoregresia(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup,kalibracia)

    tunel = zeros(3, vystup - kalibracia-pocetPredikovanych);
    data = data(zaciatok:end);
    for t = 1:vystup-kalibracia-dlzkaOkna-pocetPredikovanych
        u = data(t:end);
    
        % bazicka matica - to iste ako pri normalnej ar
        for prem=1:dlzkaOkna
            B(prem,:) = u(prem:kalibracia+prem-1);
        end
        
        % procesy na natrenovanie posunute pre kazde prediokvane...
        for prem=1:pocetPredikovanych
            f(prem,:) = u(dlzkaOkna+prem:dlzkaOkna+kalibracia+prem - 1);
        end
        
        c = (f*B')*(B*B')^(-1);  % koeficienty pre predikciu
       
        % vektor z ktocyh predikujem? Lebo najskro si nacvicim tie koeficienty a
        % potom na sto hodnotach predikujem 10, vsak?
        vektorPredchodcov = u(kalibracia+1-dlzkaOkna:kalibracia);
        
        %predikujem, zakazdym si zoberem novy riadok c, teda koeficienty pre dasliu
        %hodnotu, salala
        for prem = 1:pocetPredikovanych
            fpredikovane(prem) = c(prem,:)*vektorPredchodcov';
        end
    
        hodnotyDoTunela = fpredikovane;
        so = std(hodnotyDoTunela);
        sh = mean(hodnotyDoTunela);
        tunel(1, t) = sh + 2*so;
        tunel(2, t) = sh - 2*so;
    
        tunel(3,t) = hodnotyDoTunela(1);
    end

end