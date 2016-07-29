function plotClass(X, label)
[d,n] = size(X);

color = 'brgmcyk';
m = length(color);
c = max(label);

figure(gcf);
clf;
hold on;
view(2);
for i = 1:c
    idc = label==i;
    scatter(X(1,idc),X(2,idc),36,color(mod(i-1,m)+1));
end
axis equal
grid on
hold off