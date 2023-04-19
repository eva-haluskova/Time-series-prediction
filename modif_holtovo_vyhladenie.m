% Výpočet modifikovaného holtovho vyhladenia

function vyhladeneData = modif_holtovo_vyhladenie(data, alfa, beta, k)
        
    a(1)=data(1);
    b(1)=0;
    Ho(1) = a(1)+k*b(1);
    
    n = length(data);

    for t=2:n
        a(t) = alfa*data(t)+(1-alfa)*Ho(t-1);
        b(t) = beta*(a(t)-a(t-1))+(1-beta)*b(t-1);
        Ho(t) = a(t)+k*b(t);
    end

    vyhladeneData = Ho;
end
