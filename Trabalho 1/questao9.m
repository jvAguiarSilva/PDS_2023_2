% 1) Carregar os sinais de áudio de teste
load InputDataTest.mat

% Separar os sinais em "Sim" e "Não"
SimSignalsTest = InputDataTest(:, 4:7);
NaoSignalsTest = InputDataTest(:, 1:3);

% Definir o tamanho desejado para os sinais
tamanhoDesejado = 60000;

% Preencher os sinais de teste com zeros para ter um tamanho de 60000
SimSignalsTest = preencherComZeros(SimSignalsTest, tamanhoDesejado);
NaoSignalsTest = preencherComZeros(NaoSignalsTest, tamanhoDesejado);


% 2) Dividir os sinais em 80 blocos de N/80 amostras e calcular a energia

% Definir o número de blocos desejados
numBlocos = 80;

% Inicializar matrizes para armazenar as energias
energiasSimTest = zeros(numBlocos, 4);
energiasNaoTest = zeros(numBlocos, 3);

% Calcular o tamanho de cada bloco
tamanhoBloco = floor(length(SimSignalsTest) / numBlocos);

% Dividir e calcular as energias para os sinais "Sim" de teste
for i = 1:4
    sinalSimTest = SimSignalsTest(:, i);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = sinalSimTest(inicio:fim);
        energiasSimTest(j, i) = sum(bloco.^2);
    end
end

% Dividir e calcular as energias para os sinais "Não" de teste
for i = 1:3
    sinalNaoTest = NaoSignalsTest(:, i);
    for j = 1:numBlocos
        inicio = (j - 1) * tamanhoBloco + 1;
        fim = j * tamanhoBloco;
        bloco = sinalNaoTest(inicio:fim);
        energiasNaoTest(j, i) = sum(bloco.^2);
    end
end

% 3) Calcular o módulo ao quadrado da Transformada de Fourier (TF) e plotar

% Número de pontos da TF
N = length(SimSignalsTest);

% Frequências correspondentes aos pontos da TF
frequencias = (-pi:2*pi/N:pi-2*pi/N);

% Inicializar matrizes para armazenar as TFs
TFsSimTest = zeros(N, 4);
TFsNaoTest = zeros(N, 3);

% Calcular o módulo ao quadrado da TF para os sinais "Sim" de teste
for i = 1:4
    sinalSimTest = SimSignalsTest(:, i);
    TF = abs(fftshift(fft(sinalSimTest))).^2;
    TFsSimTest(:, i) = TF;
end

% Calcular o módulo ao quadrado da TF para os sinais "Não" de teste
for i = 1:3
    sinalNaoTest = NaoSignalsTest(:, i);
    TF = abs(fftshift(fft(sinalNaoTest))).^2;
    TFsNaoTest(:, i) = TF;
end

% 4) Eliminar frequências negativas e acima de pi/2 das TFs e plotar

% Selecionar apenas as frequências entre 0 e pi/2
frequencias = frequencias(N/2+1:N);
TFsSimTest = TFsSimTest(N/2+1:N, :);
TFsNaoTest = TFsNaoTest(N/2+1:N, :);

% 5) Dividir as TFs em 80 blocos de N/320 amostras e calcular a energia

% Definir o número de blocos desejados
numBlocosTF = 80;

% Inicializar matrizes para armazenar as energias das TFs
energiasTFBlocosSimTest = zeros(numBlocosTF, 4);
energiasTFBlocosNaoTest = zeros(numBlocosTF, 3);

% Calcular o tamanho de cada bloco da TF
tamanhoBlocoTF = floor(length(frequencias) / numBlocosTF);

% Dividir e calcular as energias para as TFs dos sinais "Sim" de teste
for i = 1:4
    TFsimTest = TFsSimTest(:, i);
    for j = 1:numBlocosTF
        inicio = (j - 1) * tamanhoBlocoTF + 1;
        fim = j * tamanhoBlocoTF;
        blocoTF = TFsimTest(inicio:fim);
        energiasTFBlocosSimTest(j, i) = sum(blocoTF);
    end
end

% Dividir e calcular as energias para as TFs dos sinais "Não" de teste
for i = 1:3
    TFnaoTest = TFsNaoTest(:, i);
    for j = 1:numBlocosTF
        inicio = (j - 1) * tamanhoBlocoTF + 1;
        fim = j * tamanhoBlocoTF;
        blocoTF = TFnaoTest(inicio:fim);
        energiasTFBlocosNaoTest(j, i) = sum(blocoTF);
    end
end

% 6) Calcular a STFT e plotar (para um sinal de cada tipo)

% Definir o número de blocos desejados para a STFT
numBlocosSTFT = 10;

% Frequências correspondentes aos pontos da STFT (de 0 a pi/2)
frequenciasSTFT = (0:pi/2/numBlocosSTFT:pi/2-pi/2/numBlocosSTFT);

% Selecionar um sinal de áudio "Sim" e um sinal de áudio "Não" para cálculo da STFT
sinalSimTest = SimSignalsTest(:, 1);
sinalNaoTest = NaoSignalsTest(:, 1);

% Dividir e calcular as STFTs para o sinal "Sim" de teste
STFTsSimTest = zeros(length(frequenciasSTFT), numBlocosSTFT);
for j = 1:numBlocosSTFT
    inicio = (j - 1) * tamanhoBlocoSTFT + 1;
    fim = j * tamanhoBlocoSTFT;
    blocoSTFT = sinalSimTest(inicio:fim);
    STFT = abs(fftshift(fft(blocoSTFT))).^2;
    STFTsSimTest(:, j) = STFT(1:length(frequenciasSTFT));
end

% Dividir e calcular as STFTs para o sinal "Não" de teste
STFTsNaoTest = zeros(length(frequenciasSTFT), numBlocosSTFT);
for j = 1:numBlocosSTFT
    inicio = (j - 1) * tamanhoBlocoSTFT + 1;
    fim = j * tamanhoBlocoSTFT;
    blocoSTFT = sinalNaoTest(inicio:fim);
    STFT = abs(fftshift(fft(blocoSTFT))).^2;
    STFTsNaoTest(:, j) = STFT(1:length(frequenciasSTFT));
end

% 7) Dividir as STFTs em 8 blocos de N/320 amostras e calcular a energia

% Definir o número de blocos desejados para a energia da STFT
numBlocosSTFTEnergia = 8;

% Inicializar matrizes para armazenar as energias das STFTs
energiasSTFTBlocosSimTest = zeros(numBlocosSTFTEnergia, numBlocosSTFT);
energiasSTFTBlocosNaoTest = zeros(numBlocosSTFTEnergia, numBlocosSTFT);

% Calcular o tamanho de cada bloco da STFT para energia
tamanhoBlocoSTFTEnergia = floor(numBlocosSTFT / numBlocosSTFTEnergia);

% Dividir e calcular as energias para as STFTs do sinal "Sim" de teste
for k = 1:numBlocosSTFTEnergia
    inicio = (k - 1) * tamanhoBlocoSTFTEnergia + 1;
    fim = k * tamanhoBlocoSTFTEnergia;
    blocoSTFT = STFTsSimTest(:, inicio:fim);
    energiaSTFT = sum(sum(blocoSTFT));
    energiasSTFTBlocosSimTest(k, :) = energiaSTFT;
end

% Dividir e calcular as energias para as STFTs do sinal "Não" de teste
for k = 1:numBlocosSTFTEnergia
    inicio = (k - 1) * tamanhoBlocoSTFTEnergia + 1;
    fim = k * tamanhoBlocoSTFTEnergia;
    blocoSTFT = STFTsNaoTest(:, inicio:fim);
    energiaSTFT = sum(sum(blocoSTFT));
    energiasSTFTBlocosNaoTest(k, :) = energiaSTFT;
end

% Agora você tem as energias calculadas para os sinais de teste nos 3 domínios.

function vetorPreenchido = preencherComZeros(vet, n)
    quantidadeZeros = n - length(vet);
    vetorZeros = zeros(quantidadeZeros, 1);
    vetorPreenchido = [vet; zeros(quantidadeZeros, size(vet, 2))];
end

