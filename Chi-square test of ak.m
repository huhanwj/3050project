n = 326;
bins = 60;
D = zeros(1,1);
N = zeros(1,bins);
for j = 1:n
    for k = 1:bins
        if Acce(1,j) >= -6 && Acce(1,j) <= 6
            if Acce(1,j) > ((k/5)-6.2) && Acce(1,j) <= (((k+1)/5)-6.2)
                N(1,k) = N(1,k) + 1;
            end
        end
    end
end
fun = @(x) (1/(2*Variance))*exp(sqrt((x-miu).^2)/(-Variance));
for j = 1:bins
    D(1,1) = D(1,1) + ((N(1,j)-(num2*integral(fun,(j/5)-6.2,((j+1)/5)-6.2))).^2)/(num2*integral(fun,(j/5)-6.2,((j+1)/5)-6.2));
end
D