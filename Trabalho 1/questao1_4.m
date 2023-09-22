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

% Plotar os sinais

% Criar uma figura para os sinais "Sim"
figure;

sinaisDeAudioSim = [S1, S2, S3, S4, S5];
labelsSim = {'Sim 1', 'Sim 2', 'Sim 3', 'Sim 4', 'Sim 5'};

% Loop para plotar cada sinal "sim"
for i = 1:5
    subplot(2, 3, i);
    plot(sinaisDeAudioSim(:, i));
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

sinaisDeAudioNao = [N1, N2, N3, N4, N5];
labelsNao = {'Não 1', 'Não 2', 'Não 3', 'Não 4', 'Não 5'};

% Loop para plotar cada sinal "não"
for i = 1:5
    subplot(2, 3, i);
    plot(sinaisDeAudioNao(:, i));
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
tamanhoBloco = floor(length(S1) / numBlocos);

% Inicialize matrizes para armazenar as energias dos blocos
energiasSim = zeros(tamanhoBloco, numBlocos);
energiasNao = zeros(tamanhoBloco, numBlocos);

% Divida e calcule as energias para os sinais "sim"
for i = 1:5
    sinalSim = eval(['S', num2str(i)]);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = sinalSim(inicio:fim);
        energiasSim(:, j) = sum(bloco.^2);
    end
end

% Divida e calcule as energias para os sinais "não"
for i = 1:5
    sinalNao = eval(['N', num2str(i)]);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = sinalNao(inicio:fim);
        energiasNao(:, j) = sum(bloco.^2);
    end
end

% Crie figuras para as energias dos sinais "sim" e "não"
figure;

% Plote as energias dos sinais "sim"
for i = 1:5
    subplot(2, 3, i);
    plot(1:numBlocos, energiasSim(i, :));
    title(['Energias Sim ', num2str(i)]);
    xlabel('Índice do Bloco');
    ylabel('Energia');
end

figure;

% Plote as energias dos sinais "não"
for i = 1:5
    subplot(2, 3, i);
    plot(1:numBlocos, energiasNao(i, :));
    title(['Energias Não ', num2str(i)]);
    xlabel('Índice do Bloco');
    ylabel('Energia');
end



% 3) Modulo ao quadrado da Transformada de Fourier
% Número de pontos da TF
N = length(S1);

% Frequências correspondentes aos pontos da TF
frequencias = (-pi:2*pi/N:pi-2*pi/N);

% Calcule o módulo ao quadrado da TF para os sinais "sim"
TFsSim = zeros(N, 5);
for i = 1:5
    sinalSim = eval(['S', num2str(i)]);
    TF = abs(fftshift(fft(sinalSim))).^2;
    TFsSim(:, i) = TF;
end

% Calcule o módulo ao quadrado da TF para os sinais "não"
TFsNao = zeros(N, 5);
for i = 1:5
    sinalNao = eval(['N', num2str(i)]);
    TF = abs(fftshift(fft(sinalNao))).^2;
    TFsNao(:, i) = TF;
end

% Crie figuras para as TFs dos sinais "sim" e "não"
figure;

% Plote as TFs dos sinais "sim"
for i = 1:5
    subplot(2, 3, i);
    plot(frequencias, TFsSim(:, i));
    title(['TF Sim ', num2str(i)]);
    xlabel('Frequência (rad)');
    ylabel('Módulo ao Quadrado');
    xlim([-pi, pi]);
end

figure;

% Plote as TFs dos sinais "não"
for i = 1:5
    subplot(2, 3, i);
    plot(frequencias, TFsNao(:, i));
    title(['TF Não ', num2str(i)]);
    xlabel('Frequência (rad)');
    ylabel('Módulo ao Quadrado');
    xlim([-pi, pi]);
end



% 4) Calcule o módulo ao quadrado da TF das séries temporais "sim" e "não"
N = length(S1);  % Número de pontos da TF

% Frequências correspondentes aos pontos da TF (de 0 a pi/2)
frequencias = (0:pi/2/N:pi/2-pi/2/N);

% Inicialize matrizes para armazenar as TFs dos sinais "sim" e "não"
TFsSim = zeros(length(frequencias), 5);
TFsNao = zeros(length(frequencias), 5);

% Calcule as TFs para os sinais "sim"
for i = 1:5
    sinalSim = eval(['S', num2str(i)]);
    TF = abs(fft(sinalSim)).^2;
    TFsSim(:, i) = TF(1:length(frequencias));
end

% Calcule as TFs para os sinais "não"
for i = 1:5
    sinalNao = eval(['N', num2str(i)]);
    TF = abs(fft(sinalNao)).^2;
    TFsNao(:, i) = TF(1:length(frequencias));
end

% Crie figuras para as TFs dos sinais "sim" e "não"
figure;

% Plote as TFs dos sinais "sim"
for i = 1:5
    subplot(2, 3, i);
    plot(frequencias, TFsSim(:, i));
    title(['TF Sim ', num2str(i)]);
    xlabel('Frequência (rad)');
    ylabel('Módulo ao Quadrado');
    xlim([0, pi/2]);
end

figure;

% Plote as TFs dos sinais "não"
for i = 1:5
    subplot(2, 3, i);
    plot(frequencias, TFsNao(:, i));
    title(['TF Não ', num2str(i)]);
    xlabel('Frequência (rad)');
    ylabel('Módulo ao Quadrado');
    xlim([0, pi/2]);
end

% 5) Divida cada uma das 10 TFs em 80 blocos de N/320 amostras
numBlocos = 80;  % Número de blocos desejados

% Calcule o tamanho de cada bloco (arredondando para baixo)
tamanhoBloco = floor(length(frequencias) / numBlocos);

% Inicialize matrizes para armazenar as energias dos blocos
energiasSim = zeros(tamanhoBloco, numBlocos, 5);
energiasNao = zeros(tamanhoBloco, numBlocos, 5);

% Divida e calcule as energias para as TFs "sim"
for i = 1:5
    TFsim = TFsSim(:, i);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = TFsim(inicio:fim);
        energiasSim(:, j, i) = sum(bloco.^2);
    end
end

% Divida e calcule as energias para as TFs "não"
for i = 1:5
    TFnao = TFsNao(:, i);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = TFnao(inicio:fim);
        energiasNao(:, j, i) = sum(bloco.^2);
    end
end













function vetorPreenchido = preencherComZeros(vet, n)
    quantidadeZeros = n - length(vet);
    vetorZeros = zeros(quantidadeZeros, 1);
    vetorPreenchido = [vet; vetorZeros];
end
