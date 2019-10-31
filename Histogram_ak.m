Temp = table2array(RawDataProcess1);
Acce = zeros(1,326);
sum2 = zeros(1,1);
num2 = zeros(1,1);
miu = zeros(1,1);
Variance = zeros(1,1);
bin = -6:0.2:6;
Lap = zeros(1,numel(bin));
for i = 1:8
    Acce(1,i) = Temp(i,1);
end
for i = 10:327
    Acce(1,i-1) = Temp(i,1);
end
B = sort(Acce);
miu = (B(1,163)+B(1,164))/2;
for i = 1:326
    if Acce(1,i) <= 6 && Acce(1,i) >= -6
        sum2(1,1) = sum2(1,1) + sqrt((Acce(1,i)-miu(1,1)).^2);
        num2(1,1) = num2(1,1) + 1;
    end
end
Variance(1,1) = sum2(1,1) / num2(1,1);
Variance = Variance +0.6;
for i = 1:numel(bin)
    Lap(1,i) = (1/(2*Variance))*exp(sqrt((((i/5)-6.2)-miu).^2)/(-Variance));
end
histogram(Acce, bin, "Normalization", "pdf");
hold on;
plot(bin, Lap);