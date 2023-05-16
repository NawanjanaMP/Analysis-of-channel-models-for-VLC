phi = 60; %semi-angle at half power (deg)
m = -log(2)/log(cosd(phi)); %Lambertian order of emission
P_LED =5250; %transmitted optical power (mW)
Arx = 7.45E-6; %detector areaa of PD (sq.cm)
Ts = 1; %gain of optical filter
%index = 1.5; %refractive index of lens at the PD
FOV = 55; %FOV of the receiver (deg)
G_Con= 1; %gain of an optical concentrator

lx=0.45; ly=0.295; lz=0.5; %room dimension in (m)
h=lz; %distance between source and reciver plane (m)
[XT,YT]= meshgrid(0,0); %position of LED

Nx = lx*800; Ny= ly*800; %number of grids in the receiver plane
x=-lx/2:lx/Nx:lx/2;
y=-ly/2:ly/Ny:ly/2;
[XR, YR] = meshgrid(x, y);
D= sqrt((XR-XT).^2+ (YR-YT).^2+h^2); %distance vector from source
cos_irradiance_angle = h./D; %irradiance angle vector
cos_incidence_angle = h./D; %incidence angle vector

HLOS=((m+1)*Arx*(cos_irradiance_angle.^m).*Ts.*G_Con.*cos_incidence_angle)./(2*pi.*D.^2); %channel DC gain for source
P_rx=P_LED.*HLOS; %received power from source
P_rx(find(abs(acosd(cos_incidence_angle))> FOV)) = 0; 
%y=6.52-0.376.*D+5.43.*E(-3).*(D.^(2));
P_rx_initial =P_rx;
% P_rx_final =P_rx - (0.773.*D-0.463);
%P_rx_final =P_rx - (-3.57+12.6.*D-11.3.*(D.^(2)));
P_rx_final =P_rx + (-62.4+361.*D+694.*(D.^(2))+445.*(D.^(3)));
%P_rx_final =P_rx + (-37.9+210.*D-388.*(D.^(2))+240.*(D.^(3)));
%P_rx_final =P_rx - (58.6-736.*D+3538.*(D.^(2))-7654.*(D.^(3))+6255.*(D.^(4)));
P_rx_dBm=(10*log10(P_rx));

figure(1)
surfc(x,y,P_rx_dBm);
xlabel('Length of room [m]')
ylabel('Width of room [m]' )
zlabel('Power [dBm]' )
hold on
title('3D Plot for Received Power Distribution (dBm)' ) 

figure(2)
surfc(x,y,HLOS);
xlabel('Length of room [m]')
ylabel('Width of room [m]' )
zlabel('Channel DC Gain' )
hold on
title('3D Plot for Channel DC Gain' ) 

figure(3)
plot(D,P_rx_initial)
xlabel('Distance from LED to PD')
ylabel('Received Power (mW)')
title('3D Plot for Received Power Distribution Initially (mW)' ) 

figure(4)
plot(D,P_rx_final)
xlabel('Distance from LED to PD')
ylabel('Received Power (mW)')
title('3D Plot for Received Power Distribution (mW)-Modeltuned for actual Received Power' )

