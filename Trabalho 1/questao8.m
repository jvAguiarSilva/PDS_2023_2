% Organize as energias calculadas no domínio do tempo para "sim" e "não" em vetores
energiasTempoSim = energiasSim(:); % Transforma a matriz em um vetor coluna
energiasTempoNao = energiasNao(:);

% Agora você tem dois vetores de tamanho 80x1 representando "sim" e "não" no domínio do tempo.

% Organize as energias calculadas no domínio da TF para "sim" e "não" em vetores
energiasTFSim = energiasBlocosSim(:); % Transforma a matriz em um vetor coluna
energiasTFNao = energiasBlocosNao(:);

% Agora você tem dois vetores de tamanho 80x1 representando "sim" e "não" no domínio da TF.

% Organize as energias calculadas no domínio da STFT para "sim" e "não" em vetores
energiasSTFTSim = energiasBlocosSim(:); % Transforma a matriz em um vetor coluna
energiasSTFTNao = energiasBlocosNao(:);

% Agora você tem dois vetores de tamanho 80x1 representando "sim" e "não" no domínio da STFT.





% Calcule a média das energias para "sim" e "não" no domínio do tempo
centroideTempoSim = mean(energiasTempoSim, 2); % Vetor coluna com tamanho 80x1
centroideTempoNao = mean(energiasTempoNao, 2); % Vetor coluna com tamanho 80x1

% Calcule a média das energias para "sim" e "não" no domínio da TF
centroideTFSim = mean(energiasTFSim, 2); % Vetor coluna com tamanho 80x1
centroideTFNao = mean(energiasTFNao, 2); % Vetor coluna com tamanho 80x1

% Calcule a média das energias para "sim" e "não" no domínio da STFT
centroideSTFTSim = mean(energiasSTFTSim, 2); % Vetor coluna com tamanho 80x1
centroideSTFTNao = mean(energiasSTFTNao, 2); % Vetor coluna com tamanho 80x1
