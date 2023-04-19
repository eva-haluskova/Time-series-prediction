

%parameter dif ak 1 -> aj logaritmicke diferencie
%parameter ar ak 1 -> aj AR
%parameter plot -> pre vykreslenie sklonu priamky

function HURST = Hurst(data, dif, ar, plot)
    f = data;

    % uprava pomocou diferencialnych rovnic
    if dif == 1
        minF = min(f);
    
        if minF <= 1
            f = f + minF*(-1) + 2;
        end
    
        f = log(f(2:length(f)))-log(f(1:length(f)-1));
    end

    
    N = length(f);
    
    % odstránenia krátkodobej pamäte použijeme rezíduá AR(1) 
    if ar == 1
        fz = f(2:N);
        
        
        b1 = f(1:N-1);
        b0 = ones(1,length(b1));
        
        b = [fz*b0'
             fz*b1'];
        
        A = [ b0*b0' b0*b1' 
            b1*b0' b1*b1'];
        
        c = A\b;
        
        f = f(2:length(f))-(c(1)*ones(1,length(f)-1)+c(2)*f(1:length(f)-1));

    end

    %----------------------------------------------------------------------
    K = length(f);
    
    RS = [];
    RSN = [];
    
    
    for k = 2:K  % počet subobdobi
        n = K/k; % dlzka subobdobia
        if n < 10
            break
        end
        if mod(K,k) == 0
            for i = 0:n:K-1
                if i == 0
                    cr = i+1:i+n;
                else
                    cr = i:i+n;
                end
                m = mean(f(cr));
                Y = f(cr)-m;
                Z = cumsum(Y);
                R = max(Z) - min(Z);
                S = sqrt((1/(n))*sum((Y).^2));
                if S == 0 || R == 0
                    continue
                else
                    RS = [RS, R/S];
                    RSN = [RSN, n];
                end
            end
        end
    end
    
    %--------------------------------------------------------------------
    
    b0 = ones(1,length(RS));
    b1 = log2(RSN);
    
    b = [log2(RS)*b0'
        log2(RS)*(b1)'];
    
    A = [ b0*b0' b0*b1' 
        b1*b0' b1*b1'];
    
    c = A\b;
    HURST = c(2); 
    
    if plot == 1
        plot(b1, log2(RS), ".r",'markersize',5)
        hold on
        
        t = 0:0.01:expo;
        l = c(1) + c(2)*t;
        plot(t, l, "-g",'LineWidth',1)
        hold on
        
        t = 0:0.01:expo;
        plot(t, t, "-b",'LineWidth',1)
        hold on
    end
%}
end