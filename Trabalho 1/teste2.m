% Limpar workspace e console
clear all;
clc;

% 1) Carregar os 10 sinais de áudio de InputDataTrain.m
load InputDataTrain.mat

% Separar os sinais em "Sim" e "Não"
SinaisSim = InputDataTrain(:, 1:5);
SinaisNao = InputDataTrain(:, 6:10);

% Plotar os sinais "Sim"
figure;
for i = 1:5
    subplot(2, 3, i);
    plot(SinaisSim(:, i));
    title(['Sim ', num2str(i)]);
end

% Plotar os sinais "Não"
figure;
for i = 1:5
    subplot(2, 3, i);
    plot(SinaisNao(:, i));
    title(['Não ', num2str(i)]);
end

% 2) Dividir cada um dos 10 sinais em 80 blocos de N/80 amostras
numBlocos = 80;
tamanhoSinal = size(SinaisSim, 1); % Tamanho de cada sinal
tamanhoBloco = floor(tamanhoSinal / numBlocos);

energiasSim = zeros(tamanhoBloco, numBlocos, 5);
energiasNao = zeros(tamanhoBloco, numBlocos, 5);

for i = 1:5
    sinalSim = SinaisSim(:, i);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = sinalSim(inicio:fim);
        energiasSim(:, j, i) = sum(bloco.^2);
    end
end

for i = 1:5
    sinalNao = SinaisNao(:, i);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = sinalNao(inicio:fim);
        energiasNao(:, j, i) = sum(bloco.^2);
    end
end

% Plotar as energias dos blocos para "Sim"
figure;
for i = 1:5
    subplot(2, 3, i);
    plot(1:numBlocos, energiasSim(:, :, i));
    title(['Energias Sim ', num2str(i)]);
    xlabel('Índice do Bloco');
    ylabel('Energia');
end

% Plotar as energias dos blocos para "Não"
figure;
for i = 1:5
    subplot(2, 3, i);
    plot(1:numBlocos, energiasNao(:, :, i));
    title(['Energias Não ', num2str(i)]);
    xlabel('Índice do Bloco');
    ylabel('Energia');
end

% 3) Calcular o módulo ao quadrado da Transformada de Fourier (TF)
N = tamanhoSinal;
frequencias = (-pi:2*pi/N:pi-2*pi/N);

TFsSim = zeros(N, 5);
TFsNao = zeros(N, 5);

for i = 1:5
    sinalSim = SinaisSim(:, i);
    TF = abs(fftshift(fft(sinalSim))).^2;
    TFsSim(:, i) = TF;
end

for i = 1:5
    sinalNao = SinaisNao(:, i);
    TF = abs(fftshift(fft(sinalNao))).^2;
    TFsNao(:, i) = TF;
end

% 4) Eliminar frequências negativas e acima de pi/2 das TFs
frequencias = frequencias(N/2+1:N);
TFsSim = TFsSim(N/2+1:N, :);
TFsNao = TFsNao(N/2+1:N, :);

% 5) Dividir cada uma das 10 TFs do Item 4 em 80 blocos de N/320 amostras
numBlocosTF = 80;
tamanhoBlocoTF = floor(length(frequencias) / numBlocosTF);

energiasTFBlocosSim = zeros(tamanhoBlocoTF, numBlocosTF, 5);
energiasTFBlocosNao = zeros(tamanhoBlocoTF, numBlocosTF, 5);

for i = 1:5
    TFsim = TFsSim(:, i);
    for j = 1:numBlocosTF
        inicio = (j - 1) * tamanhoBlocoTF + 1;
        fim = j * tamanhoBlocoTF;
        blocoTF = TFsim(inicio:fim);
        energiasTFBlocosSim(:, j, i) = sum(blocoTF);
    end
end

for i = 1:5
    TFnao = TFsNao(:, i);
    for j = 1:numBlocosTF
        inicio = (j - 1) * tamanhoBlocoTF + 1;
        fim = j * tamanhoBlocoTF;
        blocoTF = TFnao(inicio:fim);
        energiasTFBlocosNao(:, j, i) = sum(blocoTF);
    end
end

% 6) Dividir cada um dos sinais de áudio (no domínio do tempo) em 10 blocos de N/10 amostras
numBlocosSTFT = 10;
tamanhoBlocoSTFT = floor(tamanhoSinal / numBlocosSTFT);

STFTSim = zeros(N/2, numBlocosSTFT, 1);
STFTNao = zeros(N/2, numBlocosSTFT, 1);

for i = 1
    sinalSim = SinaisSim(:, i);
    for j = 1:numBlocosSTFT
        inicio = (j - 1) * tamanhoBlocoSTFT + 1;
        fim = j * tamanhoBlocoSTFT;
        blocoSTFT = sinalSim(inicio:fim);
        TF = abs(fftshift(fft(blocoSTFT))).^2;
        frequenciasSTFT = frequencias(N/2+1:N);
        TF = TF(N/2+1:N);
        STFTSim(:, j, i) = TF;
    end
end

for i = 6
    sinalNao = SinaisNao(:, i-5);
    for j = 1:numBlocosSTFT
        inicio = (j - 1) * tamanhoBlocoSTFT + 1;
        fim = j * tamanhoBlocoSTFT;
        blocoSTFT = sinalNao(inicio:fim);
        TF = abs(fftshift(fft(blocoSTFT))).^2;
        frequenciasSTFT = frequencias(N/2+1:N);
        TF = TF(N/2+1:N);
        STFTNao(:, j, i-5) = TF;
    end
end

% 7) Dividir as STFTs em 8 blocos de N/320 amostras
numBlocosSTFT = 8;
tamanhoBlocoSTFT = floor(N/2 / numBlocosSTFT);

energiasSTFTBlocosSim = zeros(tamanhoBlocoSTFT, numBlocosSTFT, 5);
energiasSTFTBlocosNao = zeros(tamanhoBlocoSTFT, numBlocosSTFT, 5);

for i = 1:5
    STFTsim = STFTSim(:, :, i);
    for j = 1:numBlocosSTFT
        inicio = (j - 1) * tamanhoBlocoSTFT + 1;
        fim = j * tamanhoBlocoSTFT;
        blocoSTFT = STFTsim(inicio:fim, :);
        energiasSTFTBlocosSim(:, j, i) = sum(blocoSTFT(:).^2);
    end
end

for i = 1:5
    STFTnao = STFTNao(:, :, i);
    for j = 1:numBlocosSTFT
        inicio = (j - 1) * tamanhoBlocoSTFT + 1;
        fim = j * tamanhoBlocoSTFT;
        blocoSTFT = STFTnao(inicio:fim, :);
        energiasSTFTBlocosNao(:, j, i) = sum(blocoSTFT(:).^2);
    end
end
