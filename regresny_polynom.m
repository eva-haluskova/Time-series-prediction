% Vytvorenie tunelu pomocou regresného polynómu. Pre 100 hodnôt procesu
% vytvoríme regresný polynóm n-tého stupňa, do jeho predpisu dosadíme 10
% hodnôt. Z týchto 10 "predikovaných" hodnôt vytvoríme strdnú hodnotu a
% odchylku a kontrolujeme, či 101 hodnota procesu patrí do interválu
% I = <str.hodnota - 2*odchylka, str.hodnota + 2*odchylka> 
% Posúvame okno vždy o jedna a prepočítavame hodnoty nanovo.

function tunel = regresny_polynom(data,dlzkaOkna,pocetPredikovanych,zaciatok,vystup,polynom)

    time = linspace(1, dlzkaOkna, dlzkaOkna);
    timePredikovane = linspace(1, dlzkaOkna + pocetPredikovanych, dlzkaOkna + pocetPredikovanych);
    tunel = zeros(3, vystup - dlzkaOkna);

    for t = 1: vystup - dlzkaOkna
    u = data(zaciatok + t - 1: zaciatok + t + dlzkaOkna - 2);
    c = polyfit(time, u, polynom);
    f = polyval(c, timePredikovane);

    hodnotyDoTunela = f(dlzkaOkna + 1:end);
    so = std(hodnotyDoTunela);
    sh = mean(hodnotyDoTunela);
    tunel(1, t) = sh + 3*so;
    tunel(2, t) = sh - 3*so;

    tunel(3,t) = hodnotyDoTunela(1);
    end
end
