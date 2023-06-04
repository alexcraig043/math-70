amzn <-
function(maxlag=8)
{
	dump("amzn","c:\\M7021\\amzn.r")
	d=read.csv("c:\\M7021\\AMZN.csv")
	dat=as.character(d[,1])
	y=d$Adj.Close
	n=length(y);ti=1:n
	par(mfrow=c(1,1),mar=c(5,3,1,0))
	txML=paste("Autoregression model with",maxlag,"lags")
	plot(ti,y,type="l",ylim=c(300,2000),lwd=3,axes=F,xlab="",ylab="",main=txML)
	nix=seq(from=1,to=n,by=4)
	axis(side=1,at=nix,labels=dat[nix],las=2)
	axis(side=2,seq(from=300,to=2000,by=200))
	yy=y
	y=yy[(maxlag+1):n] #stock to predict
	X=matrix(ncol=maxlag,nrow=n-maxlag)
	for(j in 1:maxlag) 
		X[,j]=yy[(maxlag-j+1):(n-j)] # maxlag past values
	oML=lm(y~X) #autoregression model with maxlag predictors
	print(summary(oML))
	lines((maxlag+1):n,oML$fitted.values,col=2)
	legend(0,1800,c("Actual stock price",txML),lty=1,col=c(1,2),lwd=c(3,2),cex=1.5,bg="gray90")	
}
