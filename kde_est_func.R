
# Define kernel functions 
kernel_Epa <- function(x){0.75*(1-x^2)*(abs(x)<=1)} 
kernel_norm <- function(x) dnorm(x)

# Define the KDE

KED_est <- function(x,grid,h,ker){
  # inputs: 
  # x=sample; h=bandwidth; grid=grid point; ker=kernel 
  
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


# check for correcteness
n <- 200 
## sample from nrom(mu,s^2)
s <- 0.5
x <- rnorm(n, 1,s)
grid <- seq(-5,5,by=0.1)

### normal reference bandwidth selector
h <- 1.06*s*n^{-0.2}

f1 <- KED_est(x,grid,h,kernel_norm)

data <- cbind(dnorm(grid, 1,s), f1)
matplot(grid, data, lty=c(1:2),col=c(1:2), type="l")
legend(1,0.4,c("True","ker_est"),lty=c(1:2),col=c(1:2))

## sample from exp(lambda)

x <- rexp(n, 2)
grid <- seq(-1,5,by=0.1)

### random bandwidth
h <- 0.5

f2 <- KED_est(x,grid,h,kernel_norm)

data <- cbind(dexp(grid, 2), f2)
matplot(grid, data, lty=c(1:2),col=c(1:2), type="l")
legend(4,2,c("True","ker_est"),lty=c(1:2),col=c(1:2))
