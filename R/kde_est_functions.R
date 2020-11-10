# Define kernel functions 
kernel_norm <- function(x) dnorm(x)
kernel_uniform <- function(x){(abs(x)<=1)/2}
kernel_epnik <- function(x){(1-x^2)*(abs(x)<=1)*0.75}
kernel_bi <- function(x){(1-x^2)^2*(abs(x)<=1)/beta(3,0.5)}
kernel_tri <- function(x){(1-x^2)^3*(abs(x)<=1)/beta(4,0.5)}

x <- rnorm(100)
# Define the KDE
KDE_est <- function(x,grid,h,ker){
  # inputs: 
  # x=sample; h=bandwidth; grid=grid point; ker=kernel 
  
  if(ker=="normal") ker <- kernel_norm
  else if(ker=="uniform") ker <- kernel_uniform
  else if(ker=="epanechnikov") ker <- kernel_epnik
  else if(ker=="biweight") ker <- kernel_bi
  else if(ker=="triweight") ker <- kernel_tri
  
  ## Generate grid point matrix
  ng<-length(grid)
  nx<-length(x)
  x0 <- matrix(rep(1,nx*ng), nx,ng)
  
  x_mat <- x*x0
  x_grid <- grid*t(x0)
  
  ## kernel estimation
  x_ker <- x_mat - t(x_grid)
  ker_est <- ker(x_ker/h)
  f_est <- apply(ker_est,2,mean)/h
  return(f_est)
}
