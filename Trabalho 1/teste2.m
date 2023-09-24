% Limpar workspace e console
clear all;
clc;

% 1) Carregando os sinais de áudio
load InputDataTrain.mat

% Sinais Sim
S = InputDataTrain(:, 1:5);

% Sinais Nao
N = InputDataTrain(:, 6:10);

% Tamanho desejado
n = 60000;

% Preencher com zeros ou truncar para o tamanho desejado
for i = 1:5
    sinal = S(:, i);
    tamanhoAtual = length(sinal);
    
    if tamanhoAtual < n
        zerosFaltantes = n - tamanhoAtual;
        sinal = [sinal; zeros(zerosFaltantes, 1)];
    elseif tamanhoAtual > n
        sinal = sinal(1:n);
    end
    
    S(:, i) = sinal;
end

for i = 1:5
    sinal = N(:, i);
    tamanhoAtual = length(sinal);
    
    if tamanhoAtual < n
        zerosFaltantes = n - tamanhoAtual;
        sinal = [sinal; zeros(zerosFaltantes, 1)];
    elseif tamanhoAtual > n
        sinal = sinal(1:n);
    end
    
    N(:, i) = sinal;
end


% Plotar os sinais

% Criar uma figura para os sinais "Sim"
figure;
labelsSim = {'Sim 1', 'Sim 2', 'Sim 3', 'Sim 4', 'Sim 5'};

% Loop para plotar cada sinal "sim"
for i = 1:5
    subplot(2, 3, i);
    plot(S(:, i));
    title(labelsSim{i});
end

% Ajustar o espaçamento 
spacing = 0.02;
margin = 0.05;
padding = 0.02;
subplotsSim = get(gcf, 'Children');
for i = 1:length(subplotsSim)
    subplotsSim(i).Position(1) = subplotsSim(i).Position(1) + padding;
    subplotsSim(i).Position(3) = subplotsSim(i).Position(3) - 2 * padding;
    subplotsSim(i).Position(2) = subplotsSim(i).Position(2) + margin;
    subplotsSim(i).Position(4) = subplotsSim(i).Position(4) - margin;
end

% Criar uma figura para os sinais "Não"
figure;
labelsNao = {'Não 1', 'Não 2', 'Não 3', 'Não 4', 'Não 5'};

% Loop para plotar cada sinal "não"
for i = 1:5
    subplot(2, 3, i);
    plot(N(:, i));
    title(labelsNao{i});
end

% Ajustar o espaçamento
spacing = 0.02;
margin = 0.05;
padding = 0.02;
subplotsNao = get(gcf, 'Children');
for i = 1:length(subplotsNao)
    subplotsNao(i).Position(1) = subplotsNao(i).Position(1) + padding;
    subplotsNao(i).Position(3) = subplotsNao(i).Position(3) - 2 * padding;
    subplotsNao(i).Position(2) = subplotsNao(i).Position(2) + margin;
    subplotsNao(i).Position(4) = subplotsNao(i).Position(4) - margin;
end

% 2) Energia dos sinais

% Número de blocos desejados
numBlocos = 80;

% Calcule o tamanho de cada bloco
tamanhoBloco = floor(size(S, 1) / numBlocos);

% Inicialize matrizes para armazenar as energias dos blocos
energiasSim = zeros(numBlocos, 5);
energiasNao = zeros(numBlocos, 5);

% Calcule as energias para os sinais "sim"
for i = 1:5
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = S(inicio:fim, i);
        energiasSim(j, i) = sum(bloco.^2);
    end
end

% Calcule as energias para os sinais "não"
for i = 1:5
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = N(inicio:fim, i);
        energiasNao(j, i) = sum(bloco.^2);
    end
end

% Plotar as energias dos blocos

% Criar uma figura para as energias dos sinais "sim"
figure;

% Loop para plotar as energias dos sinais "sim"
for i = 1:5
    subplot(5, 1, i);
    plot(1:numBlocos, energiasSim(:, i));
    title(['Energias Sim ', num2str(i)]);
    xlabel('Índice do Bloco');
    ylabel('Energia');
end

% Criar uma figura para as energias dos sinais "não"
figure;

% Loop para plotar as energias dos sinais "não"
for i = 1:5
    subplot(5, 1, i);
    plot(1:numBlocos, energiasNao(:, i));
    title(['Energias Não ', num2str(i)]);
    xlabel('Índice do Bloco');
    ylabel('Energia');
end


function vetorPreenchido = preencherComZeros(vet, n)
    quantidadeZeros = n - length(vet);
    vetorZeros = zeros(quantidadeZeros, 1);
    vetorPreenchido = [vet; vetorZeros];
end

