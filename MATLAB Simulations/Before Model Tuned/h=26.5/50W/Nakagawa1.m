%%
theta=60;% semi?angle at half power
m=-log10 (2) / log10 (cosd(theta) ) ;%Lambertian order of emission
P_LED=24000;%transmitted optical power by individual LED
%nLED=60;
% number of LED array nLED*nLED
%P_total=nLED*nLED*P_LED;
%Total transmitted power
Adet=7.45e-6;%detector physical area of a PD in m
rho=0.9;%reflection coefficient of brown cardboard
Ts=1;%gain of an optical filter ; ignore if no filter is used
%index=1.5;%refractive index of a lens at a PD; ignore if no lens is used
FOV=55;%FOV of a receiver
G_Con=1;%gain of an optical concentrator ; ignore if no lens is used%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lx=0.305; ly=0.23; lz=0.265;% room dimension in m
h=lz;%distance betwwen led and pd
%[XT,YT,ZT]= meshgrid([-lx/4 lx/4] ,[-ly/4 ly/4] ,lz/2);
%[XT,YT] = meshgrid(0,0);
[XT,YT,ZT]= meshgrid(0,0,lz/2);
%position of Transmitter (LED)
Nx=50; Ny=50; Nz=50;
%Nx1=50; Ny1=50; Nz1=50;
%Nx = lx*10; Ny=ly*10;
% number of grid in each surface
dA=lz*ly/(Ny*Nz);
% calculation grid area
x=linspace(-lx/2 ,lx/2 ,Nx) ;
y=linspace(-ly/2 ,ly/2 ,Ny) ;
z=linspace(-lz/2 ,lz/2 ,Nz) ;
%[XR,YR,ZR]= meshgrid (x,y,-lz/2) ;
%[XR,YR]=meshgrid(x,y);
[XR,YR,ZR]= meshgrid (x,y,-lz/2) ;
%%%%%LoS%%%%%%%%
D= sqrt((XR-XT).^2+ (YR-YT).^2+h^2);
cos_irradiance_angle = h./D; 
cos_incidence_angle = h./D;

HLOS=double(((m+1)*Adet*(cos_irradiance_angle.^m).*Ts.*G_Con.*cos_incidence_angle)./(2*pi.*D.^2));
P_rx=P_LED.*HLOS;
P_rx(find(abs(acosd(cos_incidence_angle))> FOV)) = 0; 
P_rx((abs(acosd(cos_incidence_angle))> FOV)) = 0; 
P_rx_total =(P_rx);
%%
%first transmitter calculation
TP1=[XT,YT,ZT];
% transmitter position
TPV=[0 0 -1];
% transmitter position vector
RPV=[XR,YR,ZR];
% receiver position vector%%
%%%%%%%%%%%%%%%calculation for wall 1%%%%%%%%%%%%%%%%%%
WPV1=[1 0 0];
WPV2=[0 1 0];
WPV3=[-1 0 0];
WPV4=[0 -1 0];
% wall vectors
for ii=1:Nx
for jj=1:Ny
RP=[x(ii) y(jj) -lz/2] ;
% receiver position vector
h1(ii,jj)=0;
%% reflection from first wall
%count=1;
for kk=1:Ny
for ll=1:Nz
WP1=[-lx/2 y(kk) z(ll)];
D1=sqrt(dot(TP1-WP1,TP1-WP1));
%disp('D1 of wall1');
cos_phi= abs (WP1(3)- TP1(3) ) / D1;
cos_alpha=abs (TP1(1)-WP1(1) ) / D1;
D2=sqrt ( dot (WP1-RP, WP1-RP) ) ;
cos_beta=abs (WP1(1)- RP(1) ) / D2;
cos_psi=abs (WP1(3)- RP (3) ) / D2;
if abs (acosd(cos_psi) )<=FOV
h1(ii,jj)=double(h1(ii,jj)+(m+1)*Adet*rho*dA*(cos_phi^m*cos_alpha*cos_beta*cos_psi) /(2*pi^2.*D1^2*D2^2));
end
%count=count+1;
end
end
%% Reflection from second wall
h2(ii,jj)=0;
%count=1;
for kk=1:Nx
for ll=1:Nz
WP2=[x(kk) -ly/2  z(ll)];
D1=sqrt(dot(TP1-WP2,TP1-WP2));
cos_phi= abs(WP2(3)-TP1(3))/D1;
cos_alpha=abs(TP1(2)-WP2(2))/D1;
D2=sqrt(dot(WP2-RP,WP2-RP));
cos_beta=abs(WP2(2)-RP(2))/D2;
cos_psi=abs(WP2(3)-RP(3))/D2;
if abs(acosd(cos_psi))<=FOV
h2(ii,jj)=double(h2(ii,jj)+(m+1)*Adet*rho*dA*cos_phi^m*cos_alpha*cos_beta*cos_psi/(2*pi^2*D1^2*D2^2));
end
%count=count+1;
end
end

%% Reflection from third wall
h3(ii,jj)=0;
%count=1;
for kk=1:Ny
for ll=1:Nz
WP3=[lx/2 y(kk) z(ll)];
D1=sqrt(dot(TP1-WP3,TP1-WP3));
cos_phi= abs(WP3(3)-TP1(3))/D1;
cos_alpha=abs(TP1(1)-WP3(1))/D1;
D2=sqrt(dot(WP3-RP,WP3-RP));
cos_beta=abs(WP3(1)-RP(1))/D2;
cos_psi=abs(WP3(3)-RP(3))/D2;
%tau3=(D1+D2)/C;
%index=find(round(tau3/delta_t)==t_vector);
if abs(acosd(cos_psi))<=FOV
h3(ii,jj)=double(h3(ii,jj)+(m+1)*Adet*rho*dA*cos_phi^m*cos_alpha*cos_beta*cos_psi/(2*pi^2*D1^2*D2^2));
end
%count=count+1;
end
end
%% Reflection from fourth wall
h4(ii,jj)=0;
%count=1;
for kk=1:Nx
for ll=1:Nz
WP4=[x(kk) ly/2 z(ll)];
D1=sqrt(dot(TP1-WP4,TP1-WP4));
cos_phi= abs(WP4(3)-TP1(3))/D1;
cos_alpha=abs(TP1(2)-WP4(2))/D1;
D2=sqrt(dot(WP4-RP,WP4-RP));
cos_beta=abs(WP4(2)-RP(2))/D2;
cos_psi=abs(WP4(3)-RP(3))/D2;
%tau4=(D1+D2)/C;
%index=find(round(tau4/delta_t)==t_vector);
if abs(acosd(cos_psi))<=FOV
h4(ii,jj)=double(h4(ii,jj)+(m+1)*Adet*rho*dA*cos_phi^m*cos_alpha*cos_beta*cos_psi/(2*pi^2*D1^2*D2^2));
end
%count=count+1
end
end
end
end
%% calculation of the channel gain is similar to wall1
H_all= h1+h2+h3+h4;
H_final= H_all+HLOS;
P_rec_A1=h1*P_LED.*Ts.*G_Con;
% h2 , h3 and h4 are channel gain for walls 2 ,3 and 4 , respectively .
P_rec_A2=h2*P_LED.*Ts.*G_Con;
% received power from source 2 , due to symmetry no need separate
% calculations
P_rec_A3=h3*P_LED.*Ts.*G_Con;
P_rec_A4=h4*P_LED.*Ts.*G_Con;
P_rx=P_rec_A1+P_rec_A2+P_rec_A3+P_rec_A4+P_rx_total;
% P_rx_initial =P_rx;
% %P_rx_final =P_rx - (40.5-482.*D+2216.*(D.^(2))-4621.*(D.^(3))+3660.*(D.^(4)));
% %P_rx_final =P_rx - (-41+436.*D-1527.*(D.^(2))+1777.*(D.^(3)));
% P_rx_final =P_rx - (-0.809+9.34.*D-17.3.*(D.^(2)));
%P_rx_final =P_rx - (-0.447.*D+0.573);
%P_rec_1ref_dBm=10*log10 (P_rec_total_1ref);
%surf(x ,y , P_rec_1ref_dBm) ; hold on
%surf(x ,y , H_all) ;
 
%xlabel(' Length of room [m]')

%ylabel('Width of room [m]')

%zlabel('Channel DC Gain')

%hold on 
%title('3D Plot for Channel DC Gain')

figure(1)
surfc(x,y,H_final);
xlabel('Length of room [m]')
ylabel('Width of room [m]' )
zlabel('Channel DC Gain' )
hold on
title('3D Plot for Channel DC Gain' ) 

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
plot(D,P_rx)
xlabel('Distance from LED to PD')
ylabel('Received Power (mW)')
title('2D Plot for Received Power Distribution (mW)' )
