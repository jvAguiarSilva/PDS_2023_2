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

% 5) Divida as TFs em blocos e calcule as energias
numBlocos = 80;  % Número de blocos desejados

% Calcule o tamanho de cada bloco (arredondando para baixo)
tamanhoBloco = floor(length(frequencias) / numBlocos);

% Inicialize matrizes para armazenar as energias dos blocos
energiasSim = zeros(numBlocos, 5);
energiasNao = zeros(numBlocos, 5);

% Divida e calcule as energias para os sinais "sim"
for i = 1:5
    TFsim = TFsSim(:, i);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = TFsim(inicio:fim);
        energiasSim(j, i) = sum(bloco);
    end
end

% Divida e calcule as energias para os sinais "não"
for i = 1:5
    TFnao = TFsNao(:, i);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = TFnao(inicio:fim);
        energiasNao(j, i) = sum(bloco);
    end
end

% 6) Calcule a STFT de um sinal "sim" e um sinal "não"
numBlocosSTFT = 10;  % Número de blocos desejados para a STFT

% Calcule o tamanho de cada bloco da STFT (arredondando para baixo)
tamanhoBlocoSTFT = floor(length(S1) / numBlocosSTFT);

% Frequências correspondentes aos pontos da STFT (de 0 a pi/2)
frequenciasSTFT = (0:pi/2/tamanhoBlocoSTFT:pi/2-pi/2/tamanhoBlocoSTFT);

% Inicialize matrizes para armazenar as STFTs dos sinais "sim" e "não"
STFTsSim = zeros(length(frequenciasSTFT), numBlocosSTFT);
STFTsNao = zeros(length(frequenciasSTFT), numBlocosSTFT);

% Calcule a STFT para um sinal "sim" (por exemplo, o primeiro)
sinalSim = S1;
for j = 1:numBlocosSTFT
    inicio = (j - 1) * tamanhoBlocoSTFT + 1;
    fim = j * tamanhoBlocoSTFT;
    bloco = sinalSim(inicio:fim);
    STFT = abs(fftshift(fft(bloco))).^2;
    STFTsSim(:, j) = STFT(1:length(frequenciasSTFT));
end

% Calcule a STFT para um sinal "não" (por exemplo, o primeiro)
sinalNao = N1;
for j = 1:numBlocosSTFT
    inicio = (j - 1) * tamanhoBlocoSTFT + 1;
    fim = j * tamanhoBlocoSTFT;
    bloco = sinalNao(inicio:fim);
    STFT = abs(fftshift(fft(bloco))).^2;
    STFTsNao(:, j) = STFT(1:length(frequenciasSTFT));
end

% Crie figuras para as STFTs dos sinais "sim" e "não"
figure;

% Plote as STFTs dos sinais "sim"
for i = 1:numBlocosSTFT
    subplot(2, 5, i);
    plot(frequenciasSTFT, STFTsSim(:, i));
    title(['STFT Sim Bloco ', num2str(i)]);
    xlabel('Frequência (rad)');
    ylabel('Módulo ao Quadrado');
    xlim([0, pi/2]);
end

figure;

% Plote as STFTs dos sinais "não"
for i = 1:numBlocosSTFT
    subplot(2, 5, i);
    plot(frequenciasSTFT, STFTsNao(:, i));
    title(['STFT Não Bloco ', num2str(i)]);
    xlabel('Frequência (rad)');
    ylabel('Módulo ao Quadrado');
    xlim([0, pi/2]);
end



% 7)
% Número de blocos desejados
numBlocosEnergia = 8;

% Calcule o tamanho de cada bloco de energia (N/320)
tamanhoBlocoEnergia = floor(length(frequenciasSTFT) / numBlocosEnergia);

% Inicialize matrizes para armazenar as energias dos blocos
energiasSTFTsSim = zeros(numBlocosEnergia, 5, 10);
energiasSTFTsNao = zeros(numBlocosEnergia, 5, 10);

% Divida e calcule as energias para os sinais "sim"
for k = 1:10
    for i = 1:5
        STFTsim = STFTsSim(:, i);
        for j = 1:numBlocosEnergia
            inicio = (j - 1) * tamanhoBlocoEnergia + 1;
            fim = j * tamanhoBlocoEnergia;
            bloco = STFTsim(inicio:fim);
            energiasSTFTsSim(j, i, k) = sum(bloco);
        end
    end
end

% Divida e calcule as energias para os sinais "não"
for k = 1:10
    for i = 1:5
        STFTnao = STFTsNao(:, i);
        for j = 1:numBlocosEnergia
            inicio = (j - 1) * tamanhoBlocoEnergia + 1;
            fim = j * tamanhoBlocoEnergia;
            bloco = STFTnao(inicio:fim);
            energiasSTFTsNao(j, i, k) = sum(bloco);
        end
    end
end

% Agora, as matrizes energiasSTFTsSim e energiasSTFTsNao contêm as energias dos blocos
% para cada uma das 10 STFTs para sinais "sim" e "não"



% 8)
% Domínio do Tempo
numBlocos = 80;
tamanhoBloco = floor(length(S1) / numBlocos);
energiasSimTempo = zeros(tamanhoBloco, numBlocos, 5);
energiasNaoTempo = zeros(tamanhoBloco, numBlocos, 5);

% Calcule e armazene as energias para cada bloco de cada sinal "sim" e "não" no domínio do tempo
for i = 1:5
    sinalSim = eval(['S', num2str(i)]);
    sinalNao = eval(['N', num2str(i)]);
    
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        
        blocoSim = sinalSim(inicio:fim);
        blocoNao = sinalNao(inicio:fim);
        
        energiasSimTempo(:, j, i) = sum(blocoSim.^2);
        energiasNaoTempo(:, j, i) = sum(blocoNao.^2);
    end
end

% Domínio da Frequência (Transformada de Fourier - TF)
N = length(S1);
frequencias = (0:pi/2/N:pi/2-pi/2/N);

energiasSimTF = zeros(length(frequencias), 5);
energiasNaoTF = zeros(length(frequencias), 5);

% Calcule e armazene as energias para cada bloco de cada sinal "sim" e "não" no domínio da TF
for i = 1:5
    sinalSim = eval(['S', num2str(i)]);
    sinalNao = eval(['N', num2str(i)]);
    
    TFsim = abs(fftshift(fft(sinalSim))).^2;
    TFnao = abs(fftshift(fft(sinalNao))).^2;
    
    TFsim = TFsim(1:length(frequencias));
    TFnao = TFnao(1:length(frequencias));
    
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        
        blocoSim = TFsim(inicio:fim);
        blocoNao = TFnao(inicio:fim);
        
        energiasSimTF(:, j, i) = sum(blocoSim);
        energiasNaoTF(:, j, i) = sum(blocoNao);
    end
end

% Domínio da Frequência (Transformada de Fourier de Tempo Curto - STFT)
numBlocosSTFT = 10;
tamanhoBlocoSTFT = floor(length(S1) / numBlocosSTFT);
frequenciasSTFT = (0:pi/2/tamanhoBlocoSTFT:pi/2-pi/2/tamanhoBlocoSTFT);

energiasSimSTFT = zeros(length(frequenciasSTFT), numBlocosSTFT, 5);
energiasNaoSTFT = zeros(length(frequenciasSTFT), numBlocosSTFT, 5);

% Calcule e armazene as energias para cada bloco de cada sinal "sim" e "não" no domínio da STFT
for i = 1:5
    sinalSim = eval(['S', num2str(i)]);
    sinalNao = eval(['N', num2str(i)]);
    
    for j = 1:numBlocosSTFT
        inicio = (j - 1) * tamanhoBlocoSTFT + 1;
        fim = j * tamanhoBlocoSTFT;
        
        blocoSim = sinalSim(inicio:fim);
        blocoNao = sinalNao(inicio:fim);
        
        STFTsim = abs(fftshift(fft(blocoSim))).^2;
        STFTnao = abs(fftshift(fft(blocoNao))).^2;
        
        STFTsim = STFTsim(1:length(frequenciasSTFT));
        STFTnao = STFTnao(1:length(frequenciasSTFT));
        
        energiasSimSTFT(:, j, i) = sum(STFTsim);
        energiasNaoSTFT(:, j, i) = sum(STFTnao);
    end
end































