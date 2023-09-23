% 6) Cálculo da STFT dos sinais "sim" e "não" divididos em 10 blocos
numBlocosSTFT = 10;  % Número de blocos desejados para a STFT

% Calcule o tamanho de cada bloco da STFT (N/10 amostras)
tamanhoBlocoSTFT = floor(length(S1) / numBlocosSTFT);

% Frequências correspondentes aos pontos da STFT (de 0 a pi/2)
frequenciasSTFT = (0:pi/2/tamanhoBlocoSTFT:pi/2-pi/2/tamanhoBlocoSTFT);

% Inicialize matrizes para armazenar as STFTs dos sinais "sim" e "não"
STFTsSim = zeros(length(frequenciasSTFT), numBlocosSTFT, 5);
STFTsNao = zeros(length(frequenciasSTFT), numBlocosSTFT, 5);

% Divida e calcule as STFTs para um sinal "sim" (por exemplo, o primeiro)
sinalSim = S1;
for j = 1:numBlocosSTFT
    inicio = (j - 1) * tamanhoBlocoSTFT + 1;
    fim = j * tamanhoBlocoSTFT;
    bloco = sinalSim(inicio:fim);
    STFT = abs(fftshift(fft(bloco))).^2;
    STFTsSim(:, j, 1) = STFT(1:length(frequenciasSTFT));
end

% Divida e calcule as STFTs para um sinal "não" (por exemplo, o primeiro)
sinalNao = N1;
for j = 1:numBlocosSTFT
    inicio = (j - 1) * tamanhoBlocoSTFT + 1;
    fim = j * tamanhoBlocoSTFT;
    bloco = sinalNao(inicio:fim);
    STFT = abs(fftshift(fft(bloco))).^2;
    STFTsNao(:, j, 1) = STFT(1:length(frequenciasSTFT));
end


% Plote as STFTs dos sinais "sim" em uma figura
figure;

for i = 1:numBlocosSTFT
    subplot(5, 5, i);
    plot(frequenciasSTFT, STFTsSim(:, i, 1));
    title(['STFT Sim Bloco ', num2str(i)]);
    xlabel('Frequência (rad)');
    ylabel('Módulo ao Quadrado');
    xlim([0, pi/2]);
    
    % Adicione o código para ajustar o espaçamento aqui, se necessário
end

% Plote as STFTs dos sinais "não" em outra figura
figure;

for i = 1:numBlocosSTFT
    subplot(5, 5, i);
    plot(frequenciasSTFT, STFTsNao(:, i, 1));
    title(['STFT Não Bloco ', num2str(i)]);
    xlabel('Frequência (rad)');
    ylabel('Módulo ao Quadrado');
    xlim([0, pi/2]);
    
    % Adicione o código para ajustar o espaçamento aqui, se necessário
end
