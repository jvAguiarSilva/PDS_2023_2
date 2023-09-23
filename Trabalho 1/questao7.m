% Número de blocos desejados para a STFT
numBlocosSTFT = 8;

% Calcule o tamanho de cada bloco da STFT (N/320 amostras)
tamanhoBlocoSTFT = floor(N / 320);

% Inicialize matrizes para armazenar as energias dos blocos das STFTs
energiasBlocosSim = zeros(tamanhoBlocoSTFT, numBlocosSTFT * 5);
energiasBlocosNao = zeros(tamanhoBlocoSTFT, numBlocosSTFT * 5);

% Divida e calcule as energias para os sinais "sim" em cada STFT
for i = 1:5
    STFTsim = STFTsSim(:, i);
    for j = 1:numBlocosSTFT
        inicio = (j - 1) * tamanhoBlocoSTFT + 1;
        fim = j * tamanhoBlocoSTFT;
        blocoSTFT = STFTsim(inicio:fim);
        energiasBlocosSim(:, (i - 1) * numBlocosSTFT + j) = sum(abs(blocoSTFT).^2);
    end
end

% Divida e calcule as energias para os sinais "não" em cada STFT
for i = 1:5
    STFTnao = STFTsNao(:, i);
    for j = 1:numBlocosSTFT
        inicio = (j - 1) * tamanhoBlocoSTFT + 1;
        fim = j * tamanhoBlocoSTFT;
        blocoSTFT = STFTnao(inicio:fim);
        energiasBlocosNao(:, (i - 1) * numBlocosSTFT + j) = sum(abs(blocoSTFT).^2);
    end
end

% Agora você terá 80 energias para cada sinal de áudio (sim e não) em cada STFT.
