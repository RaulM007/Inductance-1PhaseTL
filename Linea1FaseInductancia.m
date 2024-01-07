%Código de cálculo de inductancia  de línea de transmisión monófasica

%Cantidad de hilos en conductor 1
h1 = size(Coor1X);
hilos1 = h1(1,2);
%Cantidad de hilos en conductor 2
h2 = size(Coor2X);
hilos2 = h2(1,2);
%Cantidad de hilos en el espacio
hilos = hilos1 + hilos2;

%% Matriz de posiciones de los hilos
posicion = zeros(hilos, 2);

for i = 1:hilos1 
       posicion(i,1) = Coor1X(i);
       posicion(i,2) = Coor1Y(i);
end

for i = 1: hilos2
       posicion(hilos1 + i,1) = Coor2X(i);
       posicion(hilos1 + i,2) = Coor2Y(i);
end

%% Matriz de distancias entre puntos
Distancias = zeros(hilos);
for i=1:hilos
    for j=1:hilos   
        if i ~= j
            %Distancias entre puntos
           deltaX = posicion(j,1) - posicion(i,1);      
           deltaY = posicion(j,2) - posicion(i,2);
  
           Distancias(i,j) = sqrt(deltaX^2 + deltaY^2);
        else
            %Radio ajustado de hilos de conductores 
            if i <= hilos1
                %Conductor 1
               Distancias(i,j) = radio1_hilos*0.7788;
            else
                %Conductor 2
               Distancias(i,j) = radio2_hilos*0.7788;
            end
        end 
    end
end

%% Cálculo de Inductancias
%Conductor 1
%Cálculo de DMG
productoDMG = 1;
for i=1:hilos1
    for j=hilos1+1:hilos
       productoDMG = productoDMG * Distancias(i,j); 
    end
end
DMG = (productoDMG)^(1/(hilos1*hilos2));

%Cálculo de RMG
productoRMG = 1;
for i=1:hilos1
    for j=1:hilos1
        productoRMG = productoRMG * Distancias(i,j);
    end
end
RMG1 = (productoRMG)^(1/(hilos1*hilos1));

%Inductancia conductor 1
InductanciaC1 = (2*10^(-7))*log(DMG/RMG1); %H/m

%Cálculo conductor 2
%Cálculo de RMG
productoRMG2 = 1;
for i= hilos1+1:hilos
    for j= hilos1+1:hilos
       productoRMG2 = productoRMG2 * Distancias(i,j); 
    end
end
RMG2 = (productoRMG2)^(1/(hilos2*hilos2));

%Inductancia conductor 2
InductanciaC2 = (2*10^(-7))*log(DMG/RMG2); %H/m

%% Cálculos finales de la línea de transmisión
%Inductancia del circuito
Inductancia = InductanciaC1 + InductanciaC2; %H/m
%Reactancia inductiva de la linea
ReactanciaXL = 2*pi*frecuencia; %Ohm/m
fprintf('\n------Resultados en H/m------\n')
fprintf('La inductancia de la línea es: %e H/m \n', Inductancia);
fprintf('La reactancia inductiva de la línea es: %e Ohm/m \n', ReactanciaXL);
fprintf('\n------Resultados en H/milla------\n')
fprintf('La inductancia de la línea es: %e H/milla \n', Inductancia/0.000621);
fprintf('La reactancia inductiva de la línea es: %e Ohm/milla \n', ReactanciaXL/0.000621);
