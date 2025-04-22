# deconvolution
R scripts for the MLE in uniform deconvolution. The scripts produce Figures like Figure 4(a) and 4(b) for the so-called fixed model in the manuscript "Nonparametric "Estimation in Uniform Deconvolution and Interval Censoring" (presently st to 10,000 samples of size n=1000). The manuscrippt is subnitted and also in this repository and on arXiv: https://arxiv.org/abs/2504.14555. Samples where hte algorithm did not converge are discarded and "count" counts the number of samples actually used.

To be able to run the scripts, you have to take care that Rcpp actually runs on your computer. The actual computation of the estimate uses the Iterative Convex Minorant Algorithm and is dibe in C++.
