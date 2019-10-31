bin = 70;
N = zeros(1,bin);
D = 0;
for i = 1:328
    for j = 1:bin
        if COG(1,i) > j+19 && COG(1,i) <= j+20
            N(1,j) = N(1,j) + 1;
        end
    end
end
fun = @(x) (1/sqrt(2*pi*Variance))*exp(((x-miu).^2)/(-2*Variance));
for i = 1:bin
    D = D + ((N(1,i) - (n*integral(fun, i+19, i+20))).^2)/(n*integral(fun, i+19, i+20));
end
D