clear all; close all;

load cosmo_expo_erosion0.dat 
ages_expo_erosion0 = cosmo_expo_erosion0(:,1);
Be_expo_erosion0 = cosmo_expo_erosion0(:,2);
Al_expo_erosion0 = cosmo_expo_erosion0(:,3);
C_expo_erosion0 = cosmo_expo_erosion0(:,4);
Ne_expo_erosion0 = cosmo_expo_erosion0(:,5);

load cosmo_expo100_erosion.dat
erosion_expo100_erosion= cosmo_expo100_erosion(:,1);
Be_expo100_erosion = cosmo_expo100_erosion(:,2);
Al_expo100_erosion = cosmo_expo100_erosion(:,3);
C_expo100_erosion = cosmo_expo100_erosion(:,4);
Ne_expo100_erosion = cosmo_expo100_erosion(:,5);

load cosmo_expo1000_erosion.dat
erosion_expo1000_erosion= cosmo_expo100_erosion(:,1);
Be_expo1000_erosion = cosmo_expo1000_erosion(:,2);
Al_expo1000_erosion = cosmo_expo1000_erosion(:,3);
C_expo1000_erosion = cosmo_expo1000_erosion(:,4);
Ne_expo1000_erosion = cosmo_expo1000_erosion(:,5);

Al_Be_ratios_expo_erosion0 = Al_expo_erosion0./Be_expo_erosion0;
Al_C_ratios_expo_erosion0 = Al_expo_erosion0./C_expo_erosion0;
C_Be_ratios_expo_erosion0 = C_expo_erosion0./Be_expo_erosion0;
Ne_Be_ratios_expo_erosion0 = Ne_expo_erosion0./Be_expo_erosion0;
Ne_C_ratios_expo_erosion0 = Ne_expo_erosion0./C_expo_erosion0;

Al_Be_ratios_expo100_erosion = Al_expo100_erosion./Be_expo100_erosion;
Al_C_ratios_expo100_erosion = Al_expo100_erosion./C_expo100_erosion;
C_Be_ratios_expo100_erosion = C_expo100_erosion./Be_expo100_erosion;
Ne_Be_ratios_expo100_erosion = Ne_expo100_erosion./Be_expo100_erosion;
Ne_C_ratios_expo100_erosion = Ne_expo100_erosion./C_expo100_erosion;

Al_Be_ratios_expo1000_erosion = Al_expo1000_erosion./Be_expo1000_erosion;
Al_C_ratios_expo1000_erosion = Al_expo1000_erosion./C_expo1000_erosion;
C_Be_ratios_expo1000_erosion = C_expo1000_erosion./Be_expo1000_erosion;
Ne_Be_ratios_expo1000_erosion = Ne_expo1000_erosion./Be_expo1000_erosion;
Ne_C_ratios_expo1000_erosion = Ne_expo1000_erosion./C_expo1000_erosion;


figure;
semilogx(Be_expo_erosion0,Al_Be_ratios_expo_erosion0,'b');
hold on
semilogx(Be_expo100_erosion,Al_Be_ratios_expo100_erosion,'r');
semilogx(Be_expo1000_erosion,Al_Be_ratios_expo1000_erosion,'m');
axis([1e7,1e10,3,7])

figure;
semilogx(Be_expo_erosion0,C_Be_ratios_expo_erosion0,'b');
hold on
semilogx(Be_expo100_erosion,C_Be_ratios_expo100_erosion,'r');
semilogx(Be_expo1000_erosion,C_Be_ratios_expo1000_erosion,'m');
axis([1e6,1e10,0,5])

figure;
semilogx(Be_expo_erosion0,Ne_Be_ratios_expo_erosion0,'b');
hold on
semilogx(Be_expo100_erosion,Ne_Be_ratios_expo100_erosion,'r');
semilogx(Be_expo1000_erosion,Ne_Be_ratios_expo1000_erosion,'m');
axis([1e6,1e10,0,8])

figure;
plot(Al_Be_ratios_expo_erosion0,C_Be_ratios_expo_erosion0,'b');
hold on
plot(Al_Be_ratios_expo100_erosion,C_Be_ratios_expo100_erosion,'r');
plot(Al_Be_ratios_expo1000_erosion,C_Be_ratios_expo1000_erosion,'m');

figure;
semilogx(C_expo_erosion0,Ne_C_ratios_expo_erosion0,'b');
hold on
semilogx(C_expo100_erosion,Ne_C_ratios_expo100_erosion,'r');
semilogx(C_expo1000_erosion,Ne_C_ratios_expo1000_erosion,'m');

figure;
semilogx(C_expo_erosion0,C_Be_ratios_expo_erosion0,'b');
hold on
semilogx(C_expo100_erosion,C_Be_ratios_expo100_erosion,'r');
semilogx(C_expo1000_erosion,C_Be_ratios_expo1000_erosion,'m');


figure;
semilogx(C_expo_erosion0,Al_C_ratios_expo_erosion0,'b');
hold on
semilogx(C_expo100_erosion,Al_C_ratios_expo100_erosion,'r');
semilogx(C_expo1000_erosion,Al_C_ratios_expo1000_erosion,'m');
