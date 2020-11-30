# Define kernel functions 
kernel_norm <- function(x) dnorm(x)
kernel_uniform <- function(x){(abs(x)<=1)/2}
kernel_epanech <- function(x){(1-x^2)*(abs(x)<=1)*0.75}
kernel_bi <- function(x){(1-x^2)^2*(abs(x)<=1)/beta(3,0.5)}
kernel_tri <- function(x){(1-x^2)^3*(abs(x)<=1)/beta(4,0.5)}

x <- rnorm(100)
# Define the KDE
KDE_est <- function(x,grid=NULL,h,ker){
  # inputs: 
  # x=sample; h=bandwidth; grid=grid point; ker=kernel 
  if(is.null(grid)) {
    grid = seq(min(x)-3*h, max(x)+3*h, length.out=512)
  }
  
  if(ker=="normal") ker <- kernel_norm
  else if(ker=="uniform") ker <- kernel_uniform
  else if(ker=="epanech") ker <- kernel_epanech
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
  return(list("f_est"=f_est, "grid"=grid))
  #return(f_est)
  
}

# Compute the MADE
made <- function(f_est,f_true) mean(abs(f_est-f_true)) 
