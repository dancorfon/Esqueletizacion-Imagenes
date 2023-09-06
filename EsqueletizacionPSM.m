close all
clear all
clc

%Coger una imagen para hacer la esqueletización
[imagen1 map1]=imread('C:\Users\danie\PSM\imagenes\e.jpg');

%Vemos como es la imagen antes de la esqueletización
figure();
imshow(imagen1); title('Imagen original')

%Calculamos el histograma de la imagen con un umbral, en la cual por cada pixel de la imagen, si su nivel de gris supera un umbral se le asocia un nivel de blanco y si es menor un nivel de negro.
%Calculamos el histograma usando el metodo de Otsu
h=graythresh(imagen1);


%Calculamos la imagen binaria y la vemos
imagen2=im2bw(imagen1,h);
%Ponemos el fondo negro y la imagen que queremos esqueletizar en blanco
imagen2= ~imagen2;
figure();
imshow(imagen2); title('Imagen binarizada');

%Normalizar imagen (conversion de datos de la imagen de uint8 a double) y calculamos la altura y anchura de la imagen
imagen3=double(imagen2);
[nfilas,ncols]=size(imagen3);

%Inicializamos las variables que vamos a utilizar
iTest=imagen3;  %Imagen que vamos a testear
imodified=imagen3;  %Imagen modificada en el proceso de adelgazamiento
N=0;  %Numero de vecinos a 0
T=0;  %Numero de vecinos a 1
iChanged=1;  %Numero de pixeles cambiados durante la iteración
Pixel=zeros(8);  %Matriz que va a contener los valores de los 8 vecinos de cada pixel


%Bucle hasta que haya recorrido todos los pixeles de la imagen
while (iChanged ~= 0)
  iChanged =0;
  for r=1:nfilas %Iteramos las filas
        for c=1:ncols %Iteramos las columnas
            if(iTest(r,c)==1)
                %Vemos los 8 vecinos de cada pixel
                Pixel(1) = 	iTest(r-1,c);
                Pixel(2) = 	iTest(r-1,c+1);
                Pixel(3) = 	iTest(r,c+1);
                Pixel(4) = 	iTest(r+1,c+1);
                Pixel(5) = 	iTest(r+1,c);
                Pixel(6) = 	iTest(r+1,c-1);
                Pixel(7) = 	iTest(r,c-1);
                Pixel(8) = 	iTest(r-1,c-1);
                N = Pixel(1)+Pixel(2)+Pixel(3)+Pixel(4)+Pixel(5)+Pixel(6)+Pixel(7)+Pixel(8); %Calculamos N
                T = 0; %Ahora calculamos T
                for i=1:7
                    if ( Pixel(i)< Pixel(i+1) )T=T+1; end %Comprobamos si Pixel(i)=0 y Pixel(i+1)=1
                end
                if ( Pixel(8)<Pixel(1) )T=T+1; end %Comprobamos si Pixel(8) es menor que Pixel(1)

                %La siguiente condicion nos dice si el pixel deberia ser eliminado
                if( (N>=2) & (N<=6) & (T==1) & ((Pixel(5)==0) | (Pixel(3)==0) | (Pixel(1)==0 & Pixel(7)==0) ) )
                    imodified(r,c)=0;
                    iChanged=iChanged+1;
                end
            end
        end
    end
    iChanged %Numero de cambios en esta iteración
    	iTest=imodified; %Intercambiamos 	iTest con imodified para la siguiente iteración
 end
 figure();
imshow(	iTest); title('Imagen resultante despues de la esqueletización')




