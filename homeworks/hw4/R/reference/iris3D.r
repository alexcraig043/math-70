iris3D <-
function(job=1,out=4)
{
dump("iris3D","c:\\QBS124\\iris3D.r")
print(date())
nm=names(iris)
flnames=as.character(iris[,5])
uflnames=unique(flnames);nfl=length(uflnames)
cl=rep(0,nrow(iris))
for(i in 1:nfl) cl[flnames==uflnames[i]]=i
allcl=c("green","blue","red")
print(cbind(uflnames,allcl))
if(job==1) # 2D scatter plots
{
	par(mfrow=c(2,3),mar=c(4.5,4.5,1,1),cex.main=1.6,cex.lab=1.5)
	
	k=0
	for(i in 1:4)
	for(j in 1:4)
	if(i>j)
	{
		plot(iris[,i],iris[,j],pch=16,cex=1.5,col=allcl[cl],xlab=nm[i],ylab=nm[j],main="")	
		k=k+1
		wher="topleft";if(k==3 | k==5) wher="topright"		
		legend(wher,uflnames,col=allcl,pch=16,cex=1.4)	
	}
}
if(job==2) #3D scatter plot
{
	par(mfrow=c(1,1),mar=c(1,1,1,1))
	X=as.matrix(iris[,1:4])
	X=X[,-out]
	nmo=nm[-out]
	op=persp(x=range(X[,1]),y=range(X[,2]),z=matrix(ncol=2,nrow=2),zlim=range(X[,3]),xlab=nmo[1],ylab=nmo[2],zlab=nmo[3],theta=35,phi=40,r=1000,main="",ticktype="detailed")
    p3=trans3d(x=X[,1], y=X[,2], z=X[,3], pmat=op)
    points(p3,pch=16,cex=1.25,col=allcl[cl])
    n=length(X[,1])
    p2=trans3d(x=X[,1], y=X[,2], z=rep(min(X[,3]),n), pmat=op)
    segments(p3$x,p3$y,p2$x,p2$y)
    points(p2,pch=4,cex=.75,col=allcl[cl])
}
if(job==3) #bird view
{
	for(theta in 1:360)
	{
		ic=as.character(theta)
		if(theta<10) ic=paste("00",ic,sep="")
		if(theta>=10 & theta<100) ic=paste("0",ic,sep="")
		fn=paste("c:\\QBS124\\iris360\\ir_",ic,".png",sep="")
		png(fn,width=1000,height=1000)
		par(mfrow=c(1,1),mar=c(3,1,1,1))
		X=as.matrix(iris[,1:4])
		X=X[,-out]
		nmo=nm[-out]
		op=persp(x=range(X[,1]),y=range(X[,2]),z=matrix(ncol=2,nrow=2),zlim=range(X[,3]),xlab=nmo[1],ylab=nmo[2],zlab=nmo[3],theta=theta,phi=40,r=1000,main="",ticktype="detailed")
		p3=trans3d(x=X[,1], y=X[,2], z=X[,3], pmat=op)
		points(p3,pch=16,cex=2,col=allcl[cl])
		n=length(X[,1])
		p2=trans3d(x=X[,1], y=X[,2], z=rep(min(X[,3]),n), pmat=op)
		segments(p3$x,p3$y,p2$x,p2$y)
		points(p2,pch=4,cex=1.5,col=allcl[cl])
		legend("topright",uflnames,pch=16,col=allcl,cex=2)
		dev.off()	
	}

	system("magick c:\\QBS124\\iris360\\*.png c:\\QBS124\\iris.gif")
}
print(date())
}
