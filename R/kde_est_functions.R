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

#' Generate the Kernel Density Estimation results
#'
#' @param x numeric vector, the samples;  
#' @param grid numeric vector, the grid points;
#' @param h positive numeric, the bandwidth; 
#' @param ker character, name of the kernel function.
#'
#' @return list of esimated densities and corresponding grid points.
#' @export
#'
#' @examples
#'KDE_est(x=rnorm(50),grid=seq(-2,2, length.out = 100),h=NULL,ker="normal")
KDE_est <- function(x,grid=NULL,h,ker="normal"){
  #- inputs: 
  #  - x: numeric vector, the samples;  
  # - grid: numeric vector, the grid points;
  # - h: positive numeric, the bandwidth; 
  # - ker: character, name of the kernel function.
  # - outputs: list of esimated densities and corresponding grid points.
  
  if(is.null(grid)) {
    grid <-  seq(min(x)-3*h, max(x)+3*h, length.out=512)
  }
  
  
  if(ker=="normal") ker <- kernel_norm
  else if(ker=="uniform") ker <- kernel_uniform
  else if(ker=="epanech") ker <- kernel_epanech
  else if(ker=="biweight") ker <- kernel_bi
  else if(ker=="triweight") ker <- kernel_tri
  
  ## Generate grid point matrix
  ng <- length(grid)
  nx <- length(x)
  x0 <- matrix(rep(1,nx*ng), nx,ng)
  
  x_mat <- x*x0
  x_grid <- grid*t(x0)
  
  if(is.null(h)) {
    h <-  1.06*sd(x)*nx^(-0.2)
  }
  
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

#' Kernel density estimation simulations over given sample size, kernel, and bandwidth
#'
#' @param x numeric vector, the large population;
#' @param n positive numeric, the sample size;
#' @param ker character, name of the kernel function;
#' @param h positive numeric, the bandwidth;
#' @param grid numeric vector, the grid points.
#'
#' @return vector of the estimated densities. 
#' @export
#'
#' @examples 
#' kde_est_big(x=rnorm(500), n=100,ker="normal", h=0.5, grid=seq(-2,2, length.out = 100))
kde_est_big <- function(x, n, ker, h, grid){
  
  #`kde_est_bid()` is to simulate over given sample size & kernel & bandwidth. 
  # - inputs:
  # - x: numeric vector, the large population;
  # - n: positive numeric, the sample size;
  # - ker: character, name of the kernel function;
  # - h: positive numeric, the bandwidth;
  # - grid: numeric vector, the grid points.
  # - output: vector of the estimated densities. 
  
  # sample from the population x with different sample size n
  l <- data.frame(n=n, ker=ker, h=h) %>% 
    mutate( x = map(.x=n, ~sample(x, .x, replace = FALSE)))
  l$n <- NULL
  
  # generate estimated densities with the sample of size n & ker & h
  est <-  purrr::pmap_dfr(l, KDE_est, grid=grid)
  est$f_est
}


#' Kernel density estimation simulations over differnt combinations of sample sizes, kernels, and bandwidths
#'
#' @param x numeric vector, the large population;  
#' @param ns numeric vector, different sample sizes;
#' @param kers character vector, names of different kernel functions;
#' @param hs positive numeric data.frame, different bandwidths;
#' @param grid numeric vector, the grid points;
#' @param true_f 
#'
#' @return list of MADEs under different combination of parameters.
#' @export
#'
#' @examples
#' # parameter setting
#' x <- rnorm(500)
#' ns <- c(100, 200)
#' kers <- c("normal","biweight")
#' hs <- data.frame(h1=0.1,h2=0.5)
#' grid <- seq(-2,2, length.out = 100)
#' true_f <- dnorm(grid)
#' 
#' sim_big_made(x, ns, kers, hs, grid, true_f)
sim_big_made <- function(x, ns, kers, hs, grid, true_f){
  # `sim_made` is used to first generate combination of parameters. 
  # Then, for each combination of parameters, `kde_est_big()` is used to 
  # generate the estimated densities, and the corresponding true densities. 
  # The `made()` is used to computae the Mean Absolute Deviation Errors(MADE). 
  
  # - inputs:
  # - x: numeric vector, the large population;  
  # - ns: numeric vector, different sample sizes;
  # - kers: character vector, names of different kernel functions;
  # - hs: positive numeric data.frame, different bandwidths;
  # - grid: numeric vector, the grid points;
  # - true_f: numeric vector, true densities.
  # - output: list of MADEs under different combination of parameters.
  # 
  
  # generates every combination of parameters (ns:kers:hs)
  simulation_params_big <- list(
    n = ns,
    kernel_type = kers,
    h = hs)
  
  est_big <- cross_df(simulation_params_big)
  r <-  purrr::pmap(list(n=100,ker="normal", h=0.1), kde_est_big,x, grid)
 
  est_big <- est_big %>% 
    mutate(
      # using `kde_est_big()` to generate the estimated densities
      f_ests =  purrr::pmap(list(n=n,ker=kernel_type, h=h), kde_est_big,x, grid),
      f_true =  purrr::map(1:length(n), ~true_f)# the corresponding true densities. 
    ) %>% 
    mutate(
      MADE =  purrr::map2_dbl(.x = f_ests, .y = f_true, ~made(.x,.y))# `made()` is used to computae the MADE. 
    )
  return(est_big$MADE)
}


##############################################################################################
# Functions that can save the result of the "sim_big_made" function in two forms.           #
##############################################################################################
save_made <- function(results,ns,kers,hs,n.sim){
  # - inputs:
  # - results: result generated from the `sim_big_made()`
  # - ns: numeric vector, different sample sizes;
  # - kers: character vector, names of different kernel functions;
  # - hs: positive numeric vector, different bandwidths;
  # - n.sim: positive numeric, number of replicates.
  # - output: list of made_mat_big and  made_comapre 
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
    n.sim = rep(n.sim, length(n)),
    # add the names(types) of the bandwidths
    bandwidth =  purrr::map_chr(.x=h, ~names(hs)[which(.x == hs)])
  ) 

  return(list(made_mat_big=made_mat_big,made_comapre=made_comapre ))
}
