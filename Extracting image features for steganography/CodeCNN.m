
vl_setup;
S=imread('Lyrica.jpg');
S = single(rgb2gray(S)) ;
[f,d] = vl_sift(S) ;
siftkey=d(:,1);
%%%%%Step 1
for i=1:16 
        T{i}=siftkey((i-1)*8+1:i*8,1); 
        temp=0;
        for j=1:8
            temp=mod(temp+T{i}(j),255);
        end
        T{i}=de2bi(temp,8);
end

[row,col]=size(S);
S=uint8(S);

H1=0;
for i=1:row 
    for j=1:col
        H1=bitxor(H1,S(i,j),'uint8');
    end
end

H2=0;
for i=1:row 
    for j=1:col
        H2=mod(H2+S(i,j),255);
    end
end

temp=0;
for i=1:16
    temp=uint16(mod(uint16(temp)+uint16(bi2de(T{i})),255));
end
S=temp;

temp=de2bi(0);
for i=1:16
    temp=xor(temp,T{i});
end
P=bi2de(temp);

Lambda=mod((uint16(T{1}(1)+T{1}(2)+T{1}(3))+uint16(H1)*uint16(H2)),255);

h= (uint16(T{1}(4)+T{1}(5)+T{1}(6)+ T{1}(7))+uint16(H1)*uint16(H2))/255;

%%%%%%%Step 2
x10=double(uint16(bi2de(T{1}))*uint16(bi2de(T{4}))*uint16(bi2de(T{7}))*uint16(S)*uint16(P))/(255^5);
x20=double(uint16(bi2de(T{2}))*uint16(bi2de(T{5}))*uint16(bi2de(T{8}))*uint16(S)*uint16(P))/(255^5);
x30=double(uint16(bi2de(T{3}))*uint16(bi2de(T{6}))*uint16(bi2de(T{9}))*uint16(S)*uint16(P))/(255^5);

N0=mod((S^2+P^2),255);





% It calculates ODE using Runge-Kutta 4th order method
h=1.5;                                             % step size
x = (x10,x20,x30);                                         % Calculates upto y(3)
y = zeros(1,length(x)); 
y(1) = 5;                                          % initial condition
F_xy = @(t,r) 3.*exp(-t)-0.4*r;                    % change the function as you desire

for i=1:(row*col)                              % calculation loop
    k_1 = F_xy(x(i),y(i));
    k_2 = F_xy(x(i)+0.5*h,y(i)+0.5*h*k_1);
    k_3 = F_xy((x(i)+0.5*h),(y(i)+0.5*h*k_2));
    k_4 = F_xy((x(i)+h),(y(i)+k_3*h));

    y(i+1) = y(i) + (1/6)*(k_1+2*k_2+2*k_3+k_4)*h;  % main equation
end




