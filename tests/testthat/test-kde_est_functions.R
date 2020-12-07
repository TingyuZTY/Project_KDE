test_that("KDE_est works", {
  r <- KDE_est(x=rnorm(50),
               grid=seq(-2,2, length.out = 100),h=NULL,
               ker="normal")$f_est
  
  expect_equal(length(r), 100)
})


test_that("made works", {
  r <- KDE_est(x=rnorm(50),
               grid=seq(-2,2, length.out = 100),h=NULL,
               ker="normal")
  
  f_true <- dnorm(r$grid)
  f_est <- r$f_est
  
  expect_equal(length(made(f_est = f_est, f_true = f_true)), 1)
})

library(tidyverse)
test_that("kde_est_big works", {
  r <- kde_est_big(x=rnorm(500), n=100,ker="normal", h=0.5, grid=seq(-2,2, length.out = 100))
  
  expect_equal(length(r), 100)
})

test_that("sim_big_made works", {
  x <- rnorm(500)
  ns <- c(100)
  kers <- c("normal")
  hs <- data.frame(0.5)
  grid <- seq(-2,2, length.out = 100)
  true_f <- dnorm(grid)
  r <- sim_big_made(x, ns, kers, hs, grid, true_f)
  
  expect_equal(length(r), 1)
})





