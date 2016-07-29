% TRABAJO PRACTICO N2

%% EJERCICIO 1

tamanio_muestra = [10 100 1000 10000 100000];
sigma = 10;
mu = 2;
valores = zeros(100000, 5);
monte_carlo = 100000;

j = 1;
while j < monte_carlo
    for n = 1:numel(tamanio_muestra)
        D=randn(1,tamanio_muestra(n))*sigma + mu;
        mu_estimado = sum(D)/tamanio_muestra(n);
        indices = sub2ind(size(valores), j, n);
        valores(indices) = mu_estimado;
    end
    j = j + 1;
end
L  = (0:0.05:2);



for n = 1:numel(tamanio_muestra)
    figure(n);
    bar(L, histc(valores(:, [n]),L), 'histc');
end

%% EJERCICIO 2

mu0=3;
sigma0=0.5;
sigma=3;
n=10000;
mu=randn(1)*sigma0 + mu0;
disp(mu);
D=randn(1,n)*sigma + mu;

mu_n=zeros(1,n);
sigma_n=zeros(1,n);
mu_n_sombrero=zeros(1,n);
w_mu0=zeros(1,n);
w_mu_n=zeros(1,n);

for i=1:n
    mu_n_sombrero(i)=mean(D(1:i));
    w_mu_n(i) = (i*sigma0^2/(i*sigma0^2+sigma^2));
    w_mu0(i) = (sigma^2/(i*sigma0^2+sigma^2));
    mu_n(i)=w_mu_n(i)*mu_n_sombrero(i)+w_mu0(i)*mu0;
    sigma_n(i)=sigma0^2*sigma^2/(i*sigma0^2+sigma^2);
end

% Display de la evolucion de las pdf's resultantes de las estimaciones.
figure(1);
x=0:0.1:5;
col=[0 0 0; 0 0 1; 0 1 0; 1 0 0; 0 1 1 ; 1 0 1; 1 1 0];
c=0;
plot(x,normpdf(x,mu0,sigma0),'Color',col(c+1,:));
hold on
for i=[10,100,500]
    c=c+1;
    plot(x,normpdf(x,mu_n(i),sigma_n(i)),'Color',col(mod(c,7)+1,:));
end
legend('p(mu)', 'n=10', 'n=100', 'n=500');
hold off

% Display de la evolucion de los mu_n y x_n
figure(2);
hold on
plot(mu_n(1:100),'r');
plot(mu_n_sombrero(1:100),'b');
legend('mu_n','mu_n sombrero');
hold off

%% Ejercicio 3

mu0=3;
sigma0=0.5;
sigma=3;
n=500;
monte_carlo = 1000
D = zeros(monte_carlo, n);
mu_n=zeros(monte_carlo,n);
sigma_n=zeros(monte_carlo,n);
mu_n_sombrero=zeros(monte_carlo,n);
w_mu0=zeros(monte_carlo,n);
w_mu_n=zeros(monte_carlo,n);


j = 1;
while j < monte_carlo
    mu=randn(1)*sigma0 + mu0;
    D(j,:)= randn(1,n)*sigma + mu;

    for i=[10,100,500]
        mu_n_sombrero(j,i)=mean(D(j, 1:i));
        w_mu_n(j,i) = (i*sigma0^2/(i*sigma0^2+sigma^2));
        w_mu0(j,i) = (sigma^2/(i*sigma0^2+sigma^2));
        mu_n(j,i)=w_mu_n(j,i)*mu_n_sombrero(j,i)+w_mu0(i)*mu0;
        sigma_n(j,i)=sigma0^2*sigma^2/(i*sigma0^2+sigma^2);
    end
    
    j = j + 1;
end