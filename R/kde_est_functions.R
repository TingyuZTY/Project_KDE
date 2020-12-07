###############################
# Define kernel functions     #
###############################
kernel_norm <- function(x) dnorm(x) # gaussian kenel
kernel_uniform <- function(x){(abs(x)<=1)/2}# uniform/box kernel
kernel_epanech <- function(x){(1-x^2)*(abs(x)<=1)*0.75}# epanech kernel
kernel_bi <- function(x){(1-x^2)^2*(abs(x)<=1)/beta(3,0.5)} # biweight kernel 
kernel_tri <- function(x){(1-x^2)^3*(abs(x)<=1)/beta(4,0.5)} # triweight kernel 

###############################
# Define the KDE function   #
##############################
KDE_est <- function(x,grid=NULL,h,ker="normal"){
  # inputs: 
  # x=sample; h=bandwidth; grid=grid point; ker=kernel 
  if(is.null(grid)) {
    grid = seq(min(x)-3*h, max(x)+3*h, length.out=512)
  }
  
  if(is.null(h)) {
    h = 1.06*sd(x)*nx^(-0.2)
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
}
###############################
#      Compute the MADE       #
###############################
made <- function(f_est,f_true) mean(abs(f_est-f_true)) 

#############################################################################################
# Functions that can simulate over different sample sizes & kernels & bandwidths.          #
# And calculate the MADE under difference settings.                                        #
#############################################################################################

#`kde_est_bid()` is to simulate over different sample sizes & kernels & bandwidths. 
# The output is the estimated densities. 

kde_est_big <- function(x, n, ker, h, grid){
  # x: large population
  # n: sample sizes
  # ker: name of kernels
  # h: bandwidths 
  # grid grid points
  
  # sample from the population x with different sample size n
  l <- data.frame(n=n, ker=ker, h=h) %>% 
    mutate( x = map(.x=n, ~sample(x, .x, replace = FALSE)))
  l$n <- NULL
  
  # generate estimated densities with the sample of size n & ker & h
  est <- pmap_dfr(l, KDE_est, grid=grid)
  est$f_est
}


# `sim_made` is to first generate combination of parameters, 
# and then for each combination of parameters, 
# using `kde_est_big()` to generate the estimated densities, and the corresponding true densities. 
# Then, `made()` is used to computae the MADE. 
# The out out is the MADEs under different combination of parameters.

sim_big_made <- function(x, ns, kes, h, grid, true_f){
  # generates every combination of parameters (ns:kers:hs)
  simulation_params_big <- list(
    n = ns,
    kernel_type = kers,
    h = hs)
  
  est_big <- cross_df(simulation_params_big)
  r <- pmap(list(n=100,ker="normal", h=0.1), kde_est_big,x, grid)
 
  est_big <- est_big %>% 
    mutate(
      # using `kde_est_big()` to generate the estimated densities
      f_ests = pmap(list(n=n,ker=kernel_type, h=h), kde_est_big,x, grid),
      f_true = map(1:length(n), ~true_f)# the corresponding true densities. 
    ) %>% 
    mutate(
      MADE = map2_dbl(.x = f_ests, .y = f_true, ~made(.x,.y))# `made()` is used to computae the MADE. 
    )
  return(est_big$MADE)
}


##############################################################################################
# Functions that can save the result of the "sim_big_made" function in two forms.           #
##############################################################################################
save_made <- function(results,ns,kers,hs,n.sim){
  # made_mat_big saves the raw simulation data 
  # made_comapre saves the mean and sd of all replications under 
  # different combianation of parameters that can be used to generate plots
  
  # save the raw data as a matrix
  made_mat_big <- matrix(unlist(results), nrow=length(ns)*length(hs)*length(kers))
  
  # calculate the mean and sd of all replications under different combianation of parameters
  made_comapre <- cross_df(list(n = ns, kernel_type = kers, h = hs)) %>% 
    mutate(made_mean=apply(made_mat_big, 1, mean),
           made_sd=apply(made_mat_big, 1, sd))
  
  # add rownames to the made_mat_big
  rownames(made_mat_big) <- paste(made_comapre$n, 
                                  made_comapre$kernel_type, 
                                  made_comapre$h, sep = ", ")
  

  made_comapre <- made_comapre %>% mutate(
    # add the number of simulations 
    n.sim = rep( n.sim, length(n)),
    # add the names(types) of the bandwidths
    bandwidth = map_chr(.x=h, ~names(hs)[which(.x == hs)])
  ) 

  return(list(made_mat_big=made_mat_big,made_comapre=made_comapre ))
}
