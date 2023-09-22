clear all;
clc;
% 1) Carregue os sinais de áudio
load Ys1.mat Ys1
load Ys2.mat Ys2
load Ys3.mat Ys3
load Yn1.mat Yn1
load Yn2.mat Yn2
load Yn3.mat Yn3

% Transformadas:

F_Yn1 = fftshift(fft(Yn1));
F_Yn2 = fftshift(fft(Yn2));
F_Yn3 = fftshift(fft(Yn3));
F_Ys1 = fftshift(fft(Ys1));
F_Ys2 = fftshift(fft(Ys2));
F_Ys3 = fftshift(fft(Ys3));

% 2) Gere o gráfico do módulo da Transformada de Fourier
figure
subplot(2, 3, 1)
plot(linspace(-pi, pi, numel(F_Ys1)), abs(F_Ys1))
title('Ys1')
subplot(2, 3, 2)
plot(linspace(-pi, pi, numel(F_Ys2)), abs(F_Ys2))
title('Ys2')
subplot(2, 3, 3)
plot(linspace(-pi, pi, numel(F_Ys3)), abs(F_Ys3))
title('Ys3')
subplot(2, 3, 4)
plot(linspace(-pi, pi, numel(F_Yn1)), abs(F_Yn1))
title('Yn1')
subplot(2, 3, 5)
plot(linspace(-pi, pi, numel(F_Yn2)), abs(F_Yn2))
title('Yn2')
subplot(2, 3, 6)
plot(linspace(-pi, pi, numel(F_Yn3)), abs(F_Yn3))
title('Yn3')


% 3) Calcule a soma dos módulos da Transformada de Fourier para as baixas frequências
FourierBaixa_n1 = sum(abs(F_Yn1(28344:35144)));
FourierBaixa_n2 = sum(abs(F_Yn2(28344:35144)));
FourierBaixa_n3 = sum(abs(F_Yn3(28344:35144)));
FourierBaixa_s1 = sum(abs(F_Ys1(28344:35144)));
FourierBaixa_s2 = sum(abs(F_Ys2(28344:35144)));
FourierBaixa_s3 = sum(abs(F_Ys3(28344:35144)));

% 4) Calcule a soma dos módulos da Transformada de Fourier para as altas frequências
FourierAlta_n1 = sum(abs(F_Yn1(35144:end))) + sum(abs(F_Yn1(1:28344)));
FourierAlta_n2 = sum(abs(F_Yn2(35144:end))) + sum(abs(F_Yn2(1:28344)));
FourierAlta_n3 = sum(abs(F_Yn3(35144:end))) + sum(abs(F_Yn3(1:28344)));
FourierAlta_s1 = sum(abs(F_Ys1(35144:end))) + sum(abs(F_Ys1(1:28344)));
FourierAlta_s2 = sum(abs(F_Ys2(35144:end))) + sum(abs(F_Ys2(1:28344)));
FourierAlta_s3 = sum(abs(F_Ys3(35144:end))) + sum(abs(F_Ys3(1:28344)));

% 5) Calcule a razão entre as somas das baixas e altas frequências
Razao_n1 = FourierAlta_n1 / FourierBaixa_n1;
Razao_n2 = FourierAlta_n2 / FourierBaixa_n2;
Razao_n3 = FourierAlta_n3 / FourierBaixa_n3;
Razao_s1 = FourierAlta_s1 / FourierBaixa_s1;
Razao_s2 = FourierAlta_s2 / FourierBaixa_s2;
Razao_s3 = FourierAlta_s3 / FourierBaixa_s3;

% 6) Calcule a média dos valores obtidos na questão 5
Razao_media = (Razao_n1 + Razao_n2 + Razao_n3 + Razao_s1 + Razao_s2 + Razao_s3) / 6;


% 7) Compare os valores obtidos na questão 5 com a média obtida na questão 6
fprintf('Yn1: "%s"\n', classificar(Razao_media, Razao_n1))
fprintf('Yn2: "%s"\n', classificar(Razao_media, Razao_n2))
fprintf('Yn3: "%s"\n', classificar(Razao_media, Razao_n3))
fprintf('Ys1: "%s"\n', classificar(Razao_media, Razao_s1))
fprintf('Ys2: "%s"\n', classificar(Razao_media, Razao_s2))
fprintf('Ys3: "%s"\n', classificar(Razao_media, Razao_s3))

function output = classificar(razao_media, razao_em_questao)
    if razao_em_questao > razao_media
        output = 'sim';
    else
        output = 'não';
    end
end