% Limpar workspace e console
clear all;
clc;

% 1) Carregando os sinais de áudio
load InputDataTrain.mat

% Sinais Sim
S1 = InputDataTrain(:,1);
S2 = InputDataTrain(:,2);
S3 = InputDataTrain(:,3);
S4 = InputDataTrain(:,4);
S5 = InputDataTrain(:,5);

% Sinais Nao
N1 = InputDataTrain(:,6);
N2 = InputDataTrain(:,7);
N3 = InputDataTrain(:,8);
N4 = InputDataTrain(:,9);
N5 = InputDataTrain(:,10);

% Tratamento dos dados - Preenchendo o final do sinal com zeros para
% torná-los divisíveis por 10;
n = 60000;

% Sinais Sim
S1 = preencherComZeros(S1, n);
S2 = preencherComZeros(S2, n);
S3 = preencherComZeros(S3, n);
S4 = preencherComZeros(S4, n);
S5 = preencherComZeros(S5, n);

% Sinais Nao
N1 = preencherComZeros(N1, n);
N2 = preencherComZeros(N2, n);
N3 = preencherComZeros(N3, n);
N4 = preencherComZeros(N4, n);
N5 = preencherComZeros(N5, n);


% 5) Divida cada uma das 10 TFs em 80 blocos de N/320 amostras
numBlocos = 80;  % Número de blocos desejados
N = length(S1);
tamanhoBloco = floor(N / (320 * numBlocos));  % Tamanho de cada bloco

% Inicialize matrizes para armazenar as energias dos blocos
energiasSim = zeros(numBlocos, 10);
energiasNao = zeros(numBlocos, 10);

% Divida e calcule as energias para as TFs "sim"
for i = 1:5
    TFsim = TFsSim(:, i);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = TFsim(inicio:fim);
        energiasSim(j, i) = sum(bloco);
    end
end

% Divida e calcule as energias para as TFs "não"
for i = 1:5
    TFnao = TFsNao(:, i);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = TFnao(inicio:fim);
        energiasNao(j, i) = sum(bloco);
    end
end

% Gere os gráficos das energias em 2 figuras separadas (sim e não)
figure;

% Plote as energias dos sinais "sim"
for i = 1:5
    subplot(2, 3, i);
    plot(1:numBlocos, energiasSim(:, i));
    title(['Energias Sim TF ', num2str(i)]);
    xlabel('Índice do Bloco');
    ylabel('Energia');
end

% Plote as energias dos sinais "não"
for i = 1:5
    subplot(2, 3, i + 5);
    plot(1:numBlocos, energiasNao(:, i));
    title(['Energias Não TF ', num2str(i)]);
    xlabel('Índice do Bloco');
    ylabel('Energia');
end



function vetorPreenchido = preencherComZeros(vet, n)
    quantidadeZeros = n - length(vet);
    vetorZeros = zeros(quantidadeZeros, 1);
    vetorPreenchido = [vet; vetorZeros];
end

