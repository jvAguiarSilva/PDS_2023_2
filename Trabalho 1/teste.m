% Questão 1: Carregando os sinais de áudio
load InputDataTrain.mat

% Separando os sinais de áudio em 'Sim' e 'Não'
S = InputDataTrain(:, 1:5);
N = InputDataTrain(:, 6:10);

% Plotar os sinais 'Sim'
figure;

labelsSim = {'Sim 1', 'Sim 2', 'Sim 3', 'Sim 4', 'Sim 5'};

% Loop para plotar cada sinal 'Sim'
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

% Plotar os sinais 'Não'
figure;

labelsNao = {'Não 1', 'Não 2', 'Não 3', 'Não 4', 'Não 5'};

% Loop para plotar cada sinal 'Não'
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

% Questão 2: Energia dos sinais no domínio do tempo

% Número de blocos desejados
numBlocos = 80;

% Calcule o tamanho de cada bloco
tamanhoBloco = floor(length(S(:, 1)) / numBlocos);

% Inicialize matrizes para armazenar as energias dos blocos no domínio do tempo
energiasSim = zeros(tamanhoBloco, numBlocos, 5);
energiasNao = zeros(tamanhoBloco, numBlocos, 5);

% Divida e calcule as energias para os sinais 'Sim'
for i = 1:5
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = S(inicio:fim, i); % Acesse o sinal 'Sim' corretamente
        energiasSim(:, j, i) = sum(bloco.^2);
    end
end

% Divida e calcule as energias para os sinais 'Não'
for i = 1:5
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = N(inicio:fim, i); % Acesse o sinal 'Não' corretamente
        energiasNao(:, j, i) = sum(bloco.^2);
    end
end

% Crie figuras para as energias dos sinais 'Sim' e 'Não' no domínio do tempo
figure;

% Plote as energias dos sinais 'Sim' no domínio do tempo
for i = 1:5
    subplot(2, 3, i);
    plot(1:numBlocos, squeeze(energiasSim(:, :, i))); % Utilize squeeze para remover dimensões extras
    title(['Energias Sim ', num2str(i)]);
    xlabel('Índice do Bloco');
    ylabel('Energia');
end

figure;

% Plote as energias dos sinais 'Não' no domínio do tempo
for i = 1:5
    subplot(2, 3, i);
    plot(1:numBlocos, squeeze(energiasNao(:, :, i))); % Utilize squeeze para remover dimensões extras
    title(['Energias Não ', num2str(i)]);
    xlabel('Índice do Bloco');
    ylabel('Energia');
end

% Questão 3: Módulo ao quadrado da Transformada de Fourier

% Número de pontos da TF
N = length(S(:, 1));

% Frequências correspondentes aos pontos da TF
frequencias = (-pi:2*pi/N:pi-2*pi/N);

% Calcule o módulo ao quadrado da TF para os sinais 'Sim'
TFsSim = zeros(N, 5);
for i = 1:5
    sinalSim = S(:, i);
    TF = abs(fftshift(fft(sinalSim))).^2;
    TFsSim(:, i) = TF;
end

% Calcule o módulo ao quadrado da TF para os sinais 'Não'
TFsNao = zeros(N, 5);
for i = 1:5
    sinalNao = N(:, i);
    TF = abs(fftshift(fft(sinalNao))).^2;
    TFsNao(:, i) = TF;
end

% Crie figuras para as TFs dos sinais 'Sim' e 'Não'
figure;

% Plote as TFs dos sinais 'Sim'
for i = 1:5
    subplot(2, 3, i);
    plot(frequencias, TFsSim(:, i));
    title(['TF Sim ', num2str(i)]);
    xlabel('Frequência (rad)');
    ylabel('Módulo ao Quadrado');
    xlim([-pi, pi]);
end

figure;

% Plote as TFs dos sinais 'Não'
for i = 1:5
    subplot(2, 3, i);
    plot(frequencias, TFsNao(:, i));
    title(['TF Não ', num2str(i)]);
    xlabel('Frequência (rad)');
    ylabel('Módulo ao Quadrado');
    xlim([-pi, pi]);
end

% Questão 4: Calcule o Módulo ao Quadrado da Transformada de Fourier das Séries Temporais 'Sim' e 'Não'

% Número de pontos da Transformada de Fourier
N = length(S(:, 1));  

% Frequências correspondentes aos pontos da Transformada de Fourier (de 0 a pi/2)
frequencias = (0:pi/2/N:pi/2-pi/2/N);

% Inicialize matrizes para armazenar as TFs dos sinais 'Sim' e 'Não'
TFsSim = zeros(length(frequencias), 5);
TFsNao = zeros(length(frequencias), 5);

% Calcule as TFs para os sinais 'Sim'
for i = 1:5
    sinalSim = S(:, i);
    TF = abs(fft(sinalSim)).^2;
    TFsSim(:, i) = TF(1:length(frequencias));
end

% Calcule as TFs para os sinais 'Não'
for i = 1:5
    sinalNao = N(:, i);
    TF = abs(fft(sinalNao)).^2;
    TFsNao(:, i) = TF(1:length(frequencias));
end

% Crie figuras para as TFs dos sinais 'Sim' e 'Não'
figure;

% Plote as TFs dos sinais 'Sim'
for i = 1:5
    subplot(2, 3, i);
    plot(frequencias, TFsSim(:, i));
    title(['TF Sim ', num2str(i)]);
    xlabel('Frequência (rad)');
    ylabel('Módulo ao Quadrado');
end

figure;

% Plote as TFs dos sinais 'Não'
for i = 1:5
    subplot(2, 3, i);
    plot(frequencias, TFsNao(:, i));
    title(['TF Não ', num2str(i)]);
    xlabel('Frequência (rad)');
    ylabel('Módulo ao Quadrado');
end

% Questão 5: Divida cada uma das 10 TFs em 80 blocos de N/320 amostras

numBlocos = 80;  % Número de blocos desejados

% Calcule o tamanho de cada bloco (arredondando para baixo)
tamanhoBloco = floor(length(frequencias) / numBlocos);

% Inicialize matrizes para armazenar as energias dos blocos
energiasSim = zeros(tamanhoBloco, numBlocos, 5);
energiasNao = zeros(tamanhoBloco, numBlocos, 5);

% Divida e calcule as energias para as TFs 'Sim'
for i = 1:5
    TFsim = TFsSim(:, i);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = TFsim(inicio:fim);
        energiasSim(:, j, i) = sum(bloco.^2);
    end
end

% Divida e calcule as energias para as TFs 'Não'
for i = 1:5
    TFnao = TFsNao(:, i);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = TFnao(inicio:fim);
        energiasNao(:, j, i) = sum(bloco.^2);
    end
end
