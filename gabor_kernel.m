function gabor_kernel = gabor_kernel(x, y, lambda, phi, sigma,gamma,theta)
%{
kern_size =100
x = linspace(-7,7,kern_size);
y = linspace(-7,7,kern_size);
[X,Y] = meshgrid(x,y);

X_theta = +X*cos(theta*pi)+Y*sin(theta*pi);
Y_theta = -X*sin(theta*pi)+Y*cos(theta*pi);

c = cos(2*pi*X_theta./lambda+phi); 
g = exp(-(X_theta.^2+gamma^2*Y_theta.^2)/2*sigma^2); 
gabor_kernel = c.*g; 
 %} 

dim1 = -7:12/x:7;
dim2 = -7:12/y:7;

[X,Y]= meshgrid(dim1,dim2);

X = X*cos(theta*pi)+Y*sin(theta*pi);
Y = -X*sin(theta*pi)+Y*cos(theta*pi);

          cosinus = cos(2*pi*(X./lambda)+phi);
          gaussiana = exp((-(X.^2+(gamma^2)*(Y.^2))/(2*sigma^2))); %%%%%%%%%%% FALLO
          gabor_kernel = cosinus.*gaussiana;
      
end