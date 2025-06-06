	library(Rcpp)
	sourceCpp("nonparMLE_unif.cpp")
	
	NumIt = 10000
	n = 1000

	upper_bound = 2	# upper bound for support
	ngrid = 19
	step=0.1
	
	variances <- matrix(0, nrow= ngrid, ncol= 2, byrow = FALSE)
	
	MLEMat2 <- matrix(0, nrow= count, ncol= ngrid, byrow = FALSE)
	
	for (i in 1: count)
	{
		for (j in 1: ngrid)
		MLEMat2[i,j]=MLEMat[i,j]
	}
		

	for (j in 1: ngrid)
	{
		variances[j,1] = j*0.1
		variances[j,2] = n^(2/3)*var(MLEMat2[,j])
	}

	
	#F0 <- function(t){(t>=0 && t<upper_bound)*(1-exp(-t))/(1-exp(-upper_bound)) + (t>=upper_bound)}
    #f0 <- function(t){(t>=0 && t<upper_bound)*exp(-t)/(1-exp(-upper_bound))}
    
     F0 <- function(t){(t>=0 && t<upper_bound)*t/upper_bound + (t>= upper_bound)}
    f0 <- function(t){(t>=0 && t<upper_bound)/upper_bound}
	
# data vectors
	S <- vector("numeric", n)
	E <- vector("numeric", n)

	data <- matrix(0, nrow= n, ncol= 2, byrow = FALSE)
	MLEMat <- matrix(0, nrow= NumIt, ncol= ngrid, byrow = FALSE)


	count =0
	
	for (iter in 1: NumIt)
	{
  		sim = iter
  	
  		print(iter)
   
		set.seed(sim)
	 
		# generate data
		for (i in 1: n)
		{ 	
			#u <- runif(1,0,1)
			#u <- -log(1-u+u*exp(-upper_bound))
			u <- runif(1,0, upper_bound)
			#v <- runif(1,0,e)
			v <- runif(1,0,1)
			S[i] <- u+v
			data[i,1] <- max(0,S[i]- 1)
			data[i,2] <- S[i]
		}

		# Compute MLE	

		output <- NPMLE(n,data,ngrid,step)
		MLE <- output$value_function
		iterations <- output$iterations
	
		if (iterations<200)
		{
			count = count+1
	    		#write(MLE,file = "MLE.txt", ncol = ngrid, append = TRUE)
			MLEMat[count,] = MLE		
		}
	}

	variances <- matrix(0, nrow= ngrid, ncol= 2, byrow = FALSE)
	
	MLEMat2 <- matrix(0, nrow= count, ncol= ngrid, byrow = FALSE)
	
	for (i in 1: count)
	{
		for (j in 1: ngrid)
		MLEMat2[i,j]=MLEMat[i,j]
	}
		

	for (j in 1: ngrid)
	{
		variances[j,1] = j*0.1
		variances[j,2] = n^(2/3)*var(MLEMat2[,j])
	}

	y <- vector("numeric", ngrid)
	y0 <- vector("numeric", ngrid)
	y1 <- vector("numeric", ngrid)
	
	for (j in 1: ngrid)
	{
		y0[j] <- 0.263555964*(4*f0(j*0.1)*F0(j*0.1)*(1-F0(j*0.1)))^(2/3)
		y1[j] <- 0.263555964*(4*f0(j*0.1)/(1/(F0(j*0.1)-F0(j*0.1-1))+1/(F0(j*0.1+1)-F0(j*0.1))))^(2/3)
		y[j] <-  variances[j,2]
	}
	
	x <- seq(0.1, ngrid*0.1, by = 0.1)

	plot(c(-1000,-1000),xlim=c(0,upper_bound), ylim=c(min(y,y0,y1),max(y,y0,y1)), main= "",ylab="",xlab="",bty="n",las=1)
   	lines(x,y,lwd=2)
   lines(x,y0,lwd=2,lty=2,col="red")
   lines(x,y1,lwd=2,lty=2,col="blue")
   
   sprintf("count = %d",count)
   