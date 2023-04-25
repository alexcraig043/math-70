excovid <-
function(n=99,SDr=0.02,ro=0.5)
{
    dump("excovid","c:\\M7021\\excovid.r")
    muy=0.1 #previous COVID rate
    one=rep(1,n) # vector of ones
    omyx=SDr^2*ro*one #omega_yx
    R10=matrix(ro,ncol=n,nrow=n) #the all-ros correlation matrix
    diag(R10)=one #the diagonal=1
    OMx=SDr^2*R10 #Omega/covariance matrix 
    iOMx=solve(OMx) #inverse Omega
    mux=muy*one
    x=rep(0.3,n) #new rates
    Eyx=muy+t(omyx)%*%iOMx%*%(x-mux) #Conditional mean = the new rate in Hanover
    cat("Expected rate in the 100th town =", Eyx)
    ro2yx=t(omyx)%*%iOMx%*%omyx/SDr^2 # coefficient of determination
    varyx=SDr^2*(1-ro2yx) #conditional/residual/unexplained variance
    cat("\nSD prediction =",sqrt(varyx),"\n")
}
