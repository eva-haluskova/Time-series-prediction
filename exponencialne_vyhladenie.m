% Výpočet exponenciálneho vyhladenia

function vyhladeneData = exponencialne_vyhladenie(data,alfa)
    n = length(data);
    vyhladeneData(1) = data(1);
    for t = 2:n
        vyhladeneData(t) = alfa*data(t) + (1-alfa)*vyhladeneData(t-1);
    end
end

