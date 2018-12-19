close all
clear all
clc

pkg load image

im = imread('C:\Users\phnf2\Pictures\Aquisição Pedro\limao (1).jpg');
figure('name','Imagem Teste'),imshow(im);

r = im(:,:,1);
b = im(:,:,3);
im2 = b-r;

his = imhist(im2);

%Pegando o segundo maior pico do histograma
pico2 = 0; 
indicePico2 = 0; %indice do segundo maior pico encontrado
for i=2:256
   if(his(i)>pico2)
      pico2 = his(i); 
      indicePico2 = i;
 end
end

%Procurando o vale entre os dois picos do histograma
vale = max(his); %valor do maior pico
indiceVale = 0;
for i=2:indicePico2
   if(his(i) < vale)
      vale = his(i); 
      indiceVale = i; 
  end
end

%Limiariza a imagem a partir do indice do vale do histograma
bin = ~(im2>indiceVale); %o ' ~ ' inverte os valores binarios para fazer a multiplicaÃ§Ã£o abaixo

semFundo = zeros(size(im,1),size(im,2),3, 'uint8');
semFundo = im.*bin; %para cada elemento(pixel) sera multiplicado o valor correspondente no binario (i,j) * 0 = 0 OU (i,j)*1 = (i,j)

figure('NAME','Imagem Sem Fundo'),imshow(semFundo);

imCinza = rgb2gray(semFundo);

%%%%%%%%%%%%% Binarização %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imBinaria = zeros(size(semFundo,1),size(semFundo,2));
imBinaria(imCinza>bin) = 1;
figure('NAME','Imagem Binaria');
imshow(imBinaria);


%%%%%%%%%%% Rotulação %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[rotulo, num] = bwlabel(imBinaria);

figure('NAME','Imagem Rotulada');
imshow(rotulo,[]);
title(strcat('Quantidade de Objetos (foreground): ',int2str(num)))

%%%%%%%%% Guardar cada objeto em uma dimensão da imagem nova %%%%%%%%%%%%%%%%%%%

vetor = unique(rotulo);
MatrizLemon = zeros(size(rotulo,1),size(rotulo,2),size(vetor,1));

cont = 1;

for z=2:size(vetor,1)
  for i=1:size(rotulo,1)
    for j=1:size(rotulo,2)
        if vetor(z) == rotulo(i,j)
          MatrizLemon(i,j,cont) = 1;
          else
          MatrizLemon(i,j,cont) = 0;
        end
    end
  end
  cont++;
end


for i=1:num
    figure(i)
    imshow(MatrizLemon(:,:,i))
end


%%%%%%%%%% Descritor de Area %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ContArea = zeros(size(vetor,1)); 
ContCor = zeros(size(vetor,1));
    
for i=1:size(rotulo,1)
  for j=1:size(rotulo,2)
    for z=1:size(vetor,1)
      if rotulo(i,j) == vetor(z)  
        ContArea(z) = ContArea(z) + 1;
      end
    end
  end
end



n=0;
for h=1:size(ContArea,1)
    if ContArea(h) > 100 && ContArea(h) < 700
     PMoeda = ContArea(h); 
    end
  end

   
%PMoeda= 216.18;
moeda = 5.72;
Cont = 0;
ContErros = 0;
Maior = 0;
aux = 0;

disp("==================================")
disp("==================================")
disp("====== Area da Moeda =============")
disp("==================================")

for z=1:size(ContArea,1)
  if ContArea(z) > 370 && ContArea(z) < 700 
    Cont++;
    AreaMoeda = (moeda.*ContArea(z))/PMoeda;
    aux = ContArea(z);
    disp("A area da Moeda de 1 real na posicao "),disp(z),...
    disp("equivale a:"),disp(AreaMoeda),disp("Cm2")
    % Area da Moeda em cm2
  end
end    
disp("==================================")
disp("==================================")
disp("====== Area dos Limoes ===========")
disp("==================================")
for z=1:size(ContArea,1)
  if ContArea(z) > 370 && ContArea(z) < 573 
    Cont++;   
  elseif ContArea(z) > Maior
    Maior = ContArea(z);
    %Pegando o Maior valor rotulado que é o fundo da imagem
  else
    RealObjeto = AreaMoeda.*ContArea(z)/aux;
    disp("O Limao rotulado na posicao"),disp(z),disp("Tem uma area igual a"),...
    disp(RealObjeto),disp("Cm2")
      %Calculando a area dos limoes 
  end
end    


%%%%%%%%%%%% Descritor de Cor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


corR = zeros(size(vetor,1)-1);
corG = zeros(size(vetor,1)-1);
corB = zeros(size(vetor,1)-1);
    
cont = 0;
  
for i=1:size(MatrizLemon,1)
  for j=1:size(MatrizLemon,2)
    for x=1:size(MatrizLemon,3)
        if MatrizLemon(i,j,x) == 1
           corR(x) = corR(x) + sum(semFundo(i,j,1));
           corG(x) = corG(x) + sum(semFundo(i,j,2));
           corB(x) = corB(x) + sum(semFundo(i,j,3));
           cont = cont + 1;
        end
    end
  end  
end 

for k=1:size(corR,1)
  cores(k,1) = corR(k)/cont;
end

for k=1:size(corG,1)
  cores(k,2) = corG(k)/cont;
end

for k=1:size(corB,1)
  cores(k,3) = corB(k)/cont;
end
disp("==================================")
disp("==================================")
disp("======== Media de Cores ==========")
disp("==================================")

disp(cores)
ContMaduro = 0;
ContVerde = 0;
ContVelho = 0;

disp("==================================")
disp("==================================")
disp("========= Resultado ==============")
disp("==================================")

for p=1:size(cores,1)
    % Maduro
  %%% Red %%% GREEN %%% BLUE %%%
   if (cores(p,1) > 21.30 && cores(p,1) < 80) && (cores(p,2) > 19 && cores(p,2) < 84) && (cores(p,3) > 9 && cores(p,3) < 45)
     ContMaduro++;
     disp("Limao Maduro na posicao:"),disp(p)
  
   elseif(cores(p,1) > 11 && cores(p,1) < 21) %verde
       if (cores(p,1) > 15 && cores(p,1) < 21)%velho
         if (cores(p,2) > 13 && cores(p,2) < 18) % velho
           if (cores(p,3) > 6 && cores(p,3) < 11) %velho
              disp("Limao Velho na posicao:"),disp(p)
              ContVelho++;   
              end         
         elseif(cores(p,2) > 13 && cores(p,2) < 29)%verde
                if(cores(p,3) > 6 && cores(p,3) < 25)
                   disp("Limao Verde na posicao:"),disp(p)
                   ContVerde++;
                   
                end
         end
     end 
  end 
end

disp("==================================")
disp("==================================")
disp("===== Quantidade por tipo ========")  
disp("==================================")
disp("Quantidade de Limoes Maduros:"),disp(ContMaduro)
disp("Quantidade de Limoes Velhos:"),disp(ContVelho)
disp("Quantidade de Limoes Verdes:"),disp(ContVerde)

%Area da moeda de 1 real é de 5,72 cm2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%)          

