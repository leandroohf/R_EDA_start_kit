##* ****************************************************************
##  Programer[s]: Leandro Fernandes
##  Company/Institution:  
##  email: leandroohf@gmail.com
##  Program: 
##  Commentary: 
##  Date: November 25, 2015
##* ****************************************************************

DataSimulator <- function(data.size){
    
    data.sim <- DataSimulator_BuildDataModel(data.size)

    ## Adding Bayes error
    sigma <- 2.0
    e = rnorm(data.size,0.0,sigma)
    data.sim$y <- data.sim$y + e 
    
    ## Create trouble var (multicolinearity)
    x5 <- -1.2*data.sim$x4 + 1.0 + rnorm(data.size,0.0,0.5)
    
    data.sim$x5 <- x5
    ## data.sim$x6 <- data.sim$x1^2
    ## data.sim$x7 <- data.sim$x2*data.sim$x3
    
    ## Append Noise Variables
    number.of.noise.vars <- 10
    data.sim <- DataSimulator_AppendNoiseVarsInDataFrame(data.sim,
                                                         number.of.noise.vars)
    list(
        GetData = function(){
            return(data.sim)
        },
        GetTrueModelFormula = function(){
            formula.str <- "y ~ x1 + I(x1^2) + x2 + x2:x3 + x4"
            return(formula.str)
        },
        GetVarsFormula = function(){

            formula.str <- paste0("x",seq(1,ncol(data.sim) - 1 ,by=1))
            formula.str <- paste0(formula.str, collapse=" + ")
            formula.str <- paste0("y ~ ",formula.str)
            
            return(formula(formula.str))
        },
        GetSigma = function(){
            ## cat("sigma: ", sigma, "\n")
            ## cat("rmse: ", sqrt(mean(e^2)), "\n")
            return(sigma)
        }
    )
}

DataSimulator_BuildDataModel <- function(data.size){

    ## Create important vars
    x1 <- rnorm(data.size,5.0,2.5)
    x2 <- rnorm(data.size,2.5,1.0)
    x3 <- rnorm(data.size,0.0,1.5)
    x4 <- rnorm(data.size,1.0,1.0)

    a0 <-  7.00
    a1 <-  2.50
    a2 <- -0.10
    a3 <-  1.00
    a4 <-  0.50
    a5 <-  0.25
    
    y <- a0 + a1*x1 + a2*x1^2 + a3*x2 + a4*x2*x3 + a5*x4

    data.sim <- data.frame(y=y,x1=x1,x2=x2,x3=x3,x4=x4)
    return(data.sim)
}

DataSimulator_AppendNoiseVarsInDataFrame <- function(data.sim,
                                                     number.of.noise.vars){

    data.size <- nrow(data.sim)
    first.noise.var <- ncol(data.sim)
    ##cat("first: ", first.noise.var, "\n")
    last.noise.var <- first.noise.var + number.of.noise.vars - 1
    ##cat("last: ", last.noise.var, "\n")
    vars.seq <- seq(first.noise.var,last.noise.var,by=1)

    cat("vars.seq:\n")
    print(vars.seq)
    print(length(vars.seq))
    print(seq(1:number.of.noise.vars))
    
    noise.vars <- paste0("x", vars.seq)

    data.sim.names <- names(data.sim)
    
    for (k in seq(1:number.of.noise.vars)) {
        
        noise.sd <- (rnorm(1,3,2))^2
        noise.mean <- rnorm(1,5,7)
        noise.x <- rnorm(data.size,noise.mean,noise.sd)

        ## cat("k; ",k,"\n")
        ## cat("noise.var: ", noise.vars[k], "\n" )
        ## cat("noise.mean: ", noise.mean, "\n" )
        ## cat("noise.sd: ", noise.sd , "\n")
        
        data.sim <- cbind(data.sim, noise.x )
        data.sim.names <- append(data.sim.names, noise.vars[k])
    }
    
    names(data.sim) <- data.sim.names
    
    return(data.sim)
}
