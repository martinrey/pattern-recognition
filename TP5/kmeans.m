function [centers, labels] = kmeans(X, c)
n = size(X,2);
k = c;
centers = zeros(2, c);

cota_superior = 1000;


for w=1:cota_superior
    r = zeros(k, n);
    labels = zeros(1, n);
    % EXPECTATION
    for i=1:n
        min_distance = inf;
        aux_distance = 0;
        min_j = 0;
        for j=1:k
            % ||Xn - MUj||^2
            aux_distance = abs(X(:,i) - centers(:,j));
            aux_distance(1) =  aux_distance(1)^2;
            aux_distance(2) =  aux_distance(2)^2;
            aux_distance = aux_distance(1) + aux_distance(2);        
            if aux_distance < min_distance
                min_distance = aux_distance;
                min_j = j;
            end
        end
        r(min_j, i) = 1;
        labels(i) = min_j;
    end
    % MAXIMIZATION
    for j=1:k
        sum_1 = 0;
        sum_2 = 0;
        for i=1:n
            sum_1 = sum_1 + r(j, i)*X(:, i);
            sum_2 = sum_2 + r(j, i);
        end
        if sum_2 == 0
            centers(:, j) = 0;
        else
            centers(:, j) = sum_1 / sum_2;
        end
    end   
end

