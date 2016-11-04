n=50000;
r=0.7;r_e=(1-r*r)^.5;
X=rnorm(n);
Y=X*r+r_e*rnorm(n);
Y=ifelse(X>0,Y,-Y);
plot(X,Y,col="pink")
