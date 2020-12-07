
# Tingyu_project_KDE

<!-- badges: start -->
<!-- badges: end -->

Name: Tingyu Zhu

Title: Kernel Density Estimation

Description:

The goal of this project is to conduct simulations to assess the performance of the kernal density estimations under different choices of kernal functions and bandwidths. And apply this method to a real dataset.


Structure:

Main parts of this project includes the following:
1. `simluation` file: demonstrates the steps of the project week by week(5-8). 
2. `analysis` file: analysis for the results of the corresponding simulations in the `simluation` file. 
3. `results` file: save the data generated during each week's `simluation`.
4. `plots` file: save the plots generated during the analysis in the `analysis` file.
5. `R` file: saves the key functions that are used to generate the Kernel Density Esitmation and simulations.

Contents:
1. Week 5: Check the correctness of the `KDE_est()` function. Illustrate the boundary effect of the KDE method. (Details can be found in `simulation_week5.pdf` in the `simulation` file)
2. Week 6: Display some commonly used kernel functions. State a way to measure the bias of the KDE. Explore the simulation results with different sample sizes & kernels with bandwidth fixed. (Details can be found in `simulation_week6.pdf` in the `simulation` file and `Summary_week6` in the `analysis` file).
3. Week 7: Simulation over different n & h & kernel. State two types of bandwidth selectors.(Details can be found in `simulation_week7.pdf` in the `simulation` file and `Summary_week7` in the `analysis` file).
4. Week 8: Apply the KDE method to a real dataset in R `beaver1`. (Details can be found in `simulation_week8.pdf` in the `simulation` file and `pre_plots` in the `analysis` file).

Presentation: 
1. Plots displayed in the presentation can be found in `pre_plots` in the `analysis` file.
2. Slide for the presentation can be found here:
https://github.com/ST541-Fall2020/Tingyu_project_KDE/blob/master/ST541_KDE_Slides_TingyuZhu.pdf

Report:
The final report can be found here: https://github.com/ST541-Fall2020/Tingyu_project_KDE/blob/master/Report.pdf

Reference:
1. https://mathisonian.github.io/kde/
2. https://en.wikipedia.org/wiki/Kernel_density_estimation
3. Chapter 5 in "Fan, J. and Yao, Q., 2008. Nonlinear time series: nonparametric and parametric methods. Springer Science & Business Media." https://doi.org/10.1007/978-0-387-69395-8
