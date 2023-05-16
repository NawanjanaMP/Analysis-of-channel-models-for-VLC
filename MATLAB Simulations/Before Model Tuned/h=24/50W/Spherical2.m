%Parameters
phi = 60;
m=- log(2)/log(cosd(phi));
P_LED= 24000;
Arx= 7.45E-6;
Ts= 1;
%index= 1.5;
FOV= 55;
Ar=2.2E-6;
p=0.9;
Aroom=0.07015;

G_Con= 1;

lx=0.58; ly=0.22; lz=0.24;
h=lz;
[XT,YT]= meshgrid(0,0);

Nx = lx*100; Ny= ly*100;
x=-lx/2:lx/Nx:lx/2;
y=-ly/2:ly/Ny:ly/2;
[XR, YR] = meshgrid(x, y); 
D= sqrt((XR-XT).^2+ (YR-YT).^2+h^2);
cos_irradiance_angle = h./D; 
cos_incidence_angle = h./D;

HLOS=((m+1)*Arx*(cos_irradiance_angle.^m).*Ts.*G_Con.*cos_incidence_angle)./(2*pi.*D.^2);
Hdiff=(Ar*p)/(Aroom*(1-p));
Htotal=(HLOS+Hdiff);
P_rx=P_LED.*Htotal;
P_rx(find(abs(acosd(cos_incidence_angle))> FOV)) = 0; 
P_rx_total =(P_rx);
% P_rx_initial =P_rx;
% %P_rx_final =P_rx - (65.3-735.*D+3532.*(D.^(2))-7641.*(D.^(3))+6245.*(D.^(4)));
% %P_rx_final =P_rx - (19.2-100.*D+273.*(D.^(2))-252.*(D.^(3)));
% P_rx_final =P_rx - (13.3-37.5.*D+54.2.*(D.^(2)));
%P_rx_dBm=(10*log10(P_rx));

figure(1)
surfc(x,y,Htotal);
xlabel('Length of room [m]')
ylabel('Width of room [m]' )
zlabel('Channel DC Gain' )
hold on
title('3D Plot for Channel DC Gain - Spherical-LoS' )

% figure(2)
% plot(D,P_rx_initial)
% xlabel('Distance from LED to PD')
% ylabel('Received Power (mW)')
% title('3D Plot for Received Power Distribution Initially (mW)' ) 
% 
% figure(3)
% plot(D,P_rx_final)
% xlabel('Distance from LED to PD')
% ylabel('Received Power (mW)')
% title('3D Plot for Received Power Distribution (mW)-Modeltuned for actual Received Power' )

figure(3)
plot(D,P_rx_total)
xlabel('Distance from LED to PD')
ylabel('Received Power (mW)')
title('2D Plot for Received Power Distribution (mW)')







