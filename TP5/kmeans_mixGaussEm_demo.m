d = 2;
c = 3;
n = 500;

[X,label] = gausseanMixtureGenerator(d,c,n);
figure(1);
plotClass(X,label);
[centers, labels] = kmeans(X,c);
figure(2);
plotClass(X,labels);
hold on
plot(centers(1,:),centers(2,:),'+')
[z, model] = mixGaussEm(X,labels);
figure(3);
plotClass(X,z);