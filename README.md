
# Tingyu_project_KDE

<!-- badges: start -->
<!-- badges: end -->

Name: Tingyu Zhu

Title: Kernel Density Estimation

## Description

The goal of this project is to conduct simulations to assess the performance of the kernal density estimations under different choices of kernal functions and bandwidths. And apply this method to a real dataset.


## Presentation 
1. Plots displayed in the presentation can be found in `pre_plots` in the `analysis` file.
2. Slide for the presentation can be found here:
https://github.com/ST541-Fall2020/Tingyu_project_KDE/blob/master/ST541_KDE_Slides_TingyuZhu.pdf

## Report
The final report can be found here: https://github.com/ST541-Fall2020/Tingyu_project_KDE/blob/master/Report.pdf


## Structure

Main parts of this project includes the following:
1. `simluation` file: demonstrates the steps of the project week by week(5-8). 
2. `analysis` file: analysis for the results of the corresponding simulations in the `simluation` folder. 
3. `results` file: save the data generated during each week's `simluation`.
4. `plots` file: save the plots generated during the analysis in the `analysis` folder.
5. `R` file: saves the key functions that are used to generate the Kernel Density Esitmation and simulations.

## Contents
1. Week 5: Check the correctness of the `KDE_est()` function. Illustrate the boundary effect of the KDE method. (Details can be found in `simulation_week5.pdf` in the `simulation` folder)
2. Week 6: Display some commonly used kernel functions. State a way to measure the bias of the KDE. Explore the simulation results with different sample sizes & kernels with bandwidth fixed. (Details can be found in `simulation_week6.pdf` in the `simulation` folder and `Summary_week6` in the `analysis` folder).
3. Week 7: Simulation over different n & h & kernel. State two types of bandwidth selectors.(Details can be found in `simulation_week7.pdf` in the `simulation` folder and `Summary_week7` in the `analysis` folder).
4. Week 8: Apply the KDE method to a real dataset in R `beaver1`. (Details can be found in `simulation_week8.pdf` in the `simulation` folder and `pre_plots` in the `analysis` folder).



## Instructions
### Packages needed:
library(tidyverse, here, ggplot2, purrr, KernSmooth)

### Execution:
The `kde_est_function.R` in the `R` folder needs to be run to perform the simulation in this project.

### Primary functions
1. KDE_est(x,grid=NULL,h,ker="normal") is used to generate the Kernel density estimation results.
   inputs: 
      x: numeric vector, the samples;  
      grid: numeric vector, the grid points;
      h: positive numeric, the bandwidth; 
      ker: character, name of the kernel function.
   outputs: list of esimated densities and corresponding grid points.


2. kde_est_big(x, n, ker, h, grid) is used to simulate over different sample sizes & kernels & bandwidths. 
   inputs:
         - x: numeric vector, the large population; \n
         - n: positive numeric, the sample size;\\
         - ker: character, name of the kernel function;
         - h: positive numeric, the bandwidth;
         - grid: numeric vector, the grid points.
   output: vector of the estimated densities. 

3. sim_big_made(x, ns, kers, hs, grid, true_f) is used to first generate combination of parameters. Then, for each combination of parameters, `kde_est_big()` is used to generate the estimated densities, and the corresponding true densities. The `made()` is used to computae the Mean Absolute Deviation Errors(MADE). 
  inputs:
      x: numeric vector, the large population;  
      ns: numeric vector, different sample sizes;
      kers: character vector, names of different kernel functions;
      hs: positive numeric vector, different bandwidths;
      grid: numeric vector, the grid points;
      true_f: numeric vector, true densities.
   output: list of MADEs under different combination of parameters.



## Reference
1. https://mathisonian.github.io/kde/
2. https://en.wikipedia.org/wiki/Kernel_density_estimation
3. Chapter 5 in "Fan, J. and Yao, Q., 2008. Nonlinear time series: nonparametric and parametric methods. Springer Science & Business Media." https://doi.org/10.1007/978-0-387-69395-8

