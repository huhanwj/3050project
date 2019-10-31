Temp = table2array(RawDataProcess1);
COG = zeros(1,328);
sum1 = 0;
sum2 = 0;
miu = 0;
Variance = 0;
n = 328;
step = 20:90;
Norm = zeros(1,numel(step));
for i = 1:8
    COG(1,i) = Temp(i,1);
end
for i = 10:329
    COG(1,i-1) = Temp(i,1);
end
for i = 1:328
    sum1 = sum1 + COG(1,i);
end
miu = sum1 / n;
for i = 1:328
    sum2 = sum2 + (COG(1,i)-miu).^2;
end
Variance = sum2 / n;
for i = 1:numel(step)
    Norm(1,i) = (1/sqrt(2*pi*Variance))*exp(((i+19-miu).^2)/(-2*Variance));
end
histogram(COG, step, "Normalization", "pdf");
hold on;
plot(step, Norm);