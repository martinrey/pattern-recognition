randn('seed',10)
S1=[.5 0 0; 0 .5 0; 0 0 .01];
S2=[1 0 0; 0 1 0; 0 0 .01];
a=6;
mv=[0 0 0; a 0 0; a/2 a/2 0; 0 a 0; -a/2 a/2 0;...
    -a 0 0; -a/2 -a/2 0; 0 -a 0; a/2 -a/2 0]';
N=100;
% Generate the dataset
X=[mvnrnd(mv(:,1),S1,N)];
for i=2:9
    X=[X; mvnrnd(mv(:,i),S2,N)];
end
X=X';
c=3; % number of classes
y=[ones(1,N) 2*ones(1,7*N) 3*ones(1,N)]; % class labels

% Plot the dataset X in the three-dimensional space
figure(3), plot3(X(1,y==1),X(2,y==1),X(3,y==1),'r.',X(1,y==2),...
    X(2,y==2),X(3,y==2),'b.',X(1,y==3),X(2,y==3),X(3,y==3),'g.')
figure(3), axis equal

% Scatter matrix computation
[Sw,Sb,Sm]=scatter_mat(X,y);

% Eigendecomposition
[V,D]=eig(inv(Sw)*Sb);

% Sort the eigenvalues in descending order and rearrange the eigenvectors accordingly
s=diag(D);
[s,ind]=sort(s,1,'descend');
V=V(:,ind);
% Select in A the eigenvectors corresponding to non-zero eigenvalues
A=V(:,1:c-1);
% Project the data set on the space spanned by the column vectors of A
Y=A'*X;

% Plot the projections of X
figure(4), plot(Y(1,y==1),Y(2,y==1),'ro',...
    Y(1,y==2),Y(2,y==2),'b.',Y(1,y==3),Y(2,y==3),'gx')
figure(4), axis equal
