cdf.dyn1 <-
function(n=100) #CDF ANIMATION CODE
{
dump("cdf.dyn1","c:\\M7021\\cdf.dyn1.r")
t0=Sys.time()

X=exp(rnorm(n,mean=1,sd=.1)) #generation of the lognormal distribution
X=sort(X)# order statistics, rearranging observations in ascending order
th=seq(from=min(X),to=max(X),length=n) #thresholds
for(i in 1:n)
{
#ch=filename with the same character length 
	ch=as.character(i)
	if(i<10) ch=paste("00",ch,sep="")
	if(i>=10 & i<100) ch=paste("0",ch,sep="")       
		
		
#The folder c:\\M7021\\cdfdyn\\ where all movie frames to be stored
	jpeg(paste("c:\\M7021\\cdfdyn\\cdf",ch,".jpg",sep=""),width=800,height=600)
	
	par(mfrow=c(1,1),mar=c(4.5,4.5,3,1),cex.lab=1.5,cex.main=1.5)
	plot(X,X,type="n",ylim=c(0,1),xlab="Data",ylab="Proportion",main=paste("CDF is the proportion of data to the left of the threshold (n=",n,")",sep=""))
	rug(X,ticksize=0.1) #show the data as little segments on the x-axis
	
	segments(th[i],-1,th[i],.05,col=2,lwd=3)
	segments(min(X)-1,0,th[i],0,col=2)
	x=seq(from=0,to=th[i],length=100)
	
	lines(x,pnorm(log(x),mean=1,sd=.1),col=4,lwd=2) #the true cdf
	Xi=c(X[X<=th[i]],th[i])
	ni=length(Xi)
	lines(Xi,(1:ni)/n,type="s",col=3,lwd=3) #the empirical cdf
	text(Xi[ni],ni/n,paste(ni/n),adj=0)
	
	legend("topleft",c("Data","Threshold","Empirical cdf","Theoretical lognormal cdf"),col=c(1,2,3,4),lwd=c(1,3,3,2),cex=1.5,bg="gray95")
	dev.off()		
}
	
system("magick c:\\M7021\\cdfdyn\\*.jpg c:\\M7021\\cdfdyn1.gif") #collect all jpegs into one FAT gif file
print(Sys.time()-t0)
}
