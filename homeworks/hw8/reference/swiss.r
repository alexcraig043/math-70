swiss <-
function(job=1)
{
dump("swiss","c:\\M7021\\swiss.r")
X=matrix(scan("c:\\M7021\\SwissBankNotes100+100.txt"),byrow=T,nrow=200)
n=nrow(X);m=ncol(X)
y=c(rep(0,100),rep(1,100))
#========================== Matrix centering and computation of Z'Z 
Z=X
for(j in 1:m)
{
	xj=X[,j]
	Z[,j]=xj-mean(xj)
}
tZZ=t(Z)%*%Z # proportional to var(X)
#return(tZZ/var(X))


if(job==0) # preliminary data column-by-column visualization 
{
	par(mfrow=c(2,3),mar=c(2,3,3,1))
	for(i in 1:6)
	{
		a=X[,i]
		plot(a,a,type="n",ylim=c(0,2),main=paste("The",i,"th dimension",sep=""),ylab="")
		rug(a[1:100], col=3,lwd=3,ticksize=0.07)
		lines(density(a[1:100]),col=3,lwd=5)
		rug(a[101:200], col=2,lwd=3,ticksize=0.035)
		lines(density(a[101:200]),col=2,lwd=5)
	}
}


if(job==1)
{
	par(mfrow=c(1,1),mar=c(4,3,3,1))
# Projection onto line using points
	a=eigen(tZZ,symmetric=T)$vectors[,1]
	print("Maximum eigenvector:")
	print(a)
	Z=X-rep(1,n)%*%t(colMeans(X))
	proj=as.vector(Z%*%a)
	plot(proj,rep(1,n),ylim=c(0,1),type="n",xlab="PCA projections",ylab="")
	title("Projection on the maximum eigenvector")
	
	rug(proj[1:100],ticksize=0.07,col=3,lwd=3)
	lines(density(proj[1:100]),col=3,lwd=5)
	rug(proj[101:200],ticksize=0.035,col=2,lwd=3)
	lines(density(proj[101:200]),col=2,lwd=5)
}
if(job==1.1) #Normalized PCA
{
# Projection onto line using segments for better visualization
# using normalized PCA

	Z=X
	for(j in 1:m)
	{
		xj=X[,j]
		Z[,j]=(xj-mean(xj))/sd(xj)/sqrt(n)
	}
	tZZ=t(Z)%*%Z
	tZZ1=cor(X)
			
	par(mfrow=c(1,1),mar=c(4,4,3,1))
	a=eigen(tZZ,symmetric=T)$vectors[,1]
	proj=as.vector(Z%*%a)
	plot(proj,rep(1,n),type="n",ylim=c(0,10),xlab="",ylab="",main="Normalized PCA does not work")
	rug(proj[1:100],ticksize=0.07,col=3,lwd=3)
	lines(density(proj[1:100]),col=3,lwd=5)
	rug(proj[101:200],ticksize=0.04,col=2,lwd=3)
	lines(density(proj[101:200]),col=2,lwd=5)
	legend("topleft",c("Genuine","Faked"),lty=1,lwd=3,col=c(3,2),cex=2)
}

if(job==2)
{
# Projection onto plane & two separation lines
	par(mfrow=c(1,1),mar=c(4.5,4.5,4,1),cex.lab=1.5,cex.main=1.5,cex.axis=1.25)
	a=eigen(tZZ,symmetric=T)$vectors[,1:2]
	Z=X-rep(1,n)%*%t(colMeans(X))
	proj=Z%*%a
	plot(proj,xlab="1st PCA component",ylab="2nd PCA component")
	title("Projection onto plane: green=genuine, red=faked")
	points(proj[1:100,],col=3,pch=16)
	points(proj[101:200,],col=2,pch=16)
	text(proj[,1],proj[,2],1:nrow(proj),adj=0)
# LDA separation
	X=proj
	X0=X[y==0,];n0=nrow(X0)
	OM0=var(X0)
	mu0=colMeans(X0)
	
	X1=X[y==1,];n1=nrow(X1)
	OM1=var(X1)
	mu1=colMeans(X1)
	
	OM=((n0-1)*OM0+(n1-1)*OM1)/(n0+n1-2)
	iOM=solve(OM)
	a=iOM%*%(mu1-mu0)
	mu=colMeans(X)
	x=c(-100,100)
	yLDA=mu[2]-(x-mu[1])*a[1]/a[2]
	lines(x,yLDA,lwd=2,col=2)		
}
if(job==2.1) #Normalized PCA
{
# Projection onto plane
	par(mfrow=c(1,1),mar=c(4.5,4.5,4,1),cex.lab=1.5,cex.main=1.5,cex.axis=1.25)
	Z=X
	meanX=colMeans(X)
	sdX=sqrt(diag(var(X)))
	for(i in 1:ncol(X)) Z[,i]=(X[,i]-meanX[i])/sdX[i]
	tZZ1=cor(Z)
	a=eigen(tZZ1,symmetric=T)$vectors[,1:2]
	proj=Z%*%a
	plot(proj,xlab="1st PCA component",ylab="2nd PCA component")
	title("Projection onto plane. Normalized PCA (green=genuine, red=faked)")
	points(proj[1:100,],col=3,pch=16)
	points(proj[101:200,],col=2,pch=16)
}
if(job==3)
{
# Quality of projection
	par(mfrow=c(1,1),mar=c(4.5,4.5,4,1),cex.lab=1.5,cex.main=1.5)
	LAMB=eigen(tZZ,symmetric=T)$values
	prv=rep(NA,ncol(tZZ))
	for(j in 1:m)
	 prv[j]=sum(LAMB[1:j])/sum(LAMB)
	plot(0:6,c(0,prv),lwd=3,type="b",xlab="PCA components",ylab="Sum of variances of first omponents")
	title("Proportion of the cumulative variance explained by PCA in counterfeit bills") 
}
if(job==4) # Projection on the plane with % variance explained
{
# Projection onto plane & two separation lines
	par(mfrow=c(1,1),mar=c(4.5,4.5,4,1),cex.lab=1.5,cex.main=1.5,cex.axis=1.25)
	a=eigen(tZZ,symmetric=T)$vectors[,1:2]
	Z=X-rep(1,n)%*%t(colMeans(X))
	proj=Z%*%a
	L12=eigen(tZZ,symmetric=T)$values
	print(L12)
	var1.expl=L12[1]/sum(L12)*100
	var2.expl=L12[2]/sum(L12)*100
	var12.expl=(L12[1]+L12[2])/sum(L12)*100
	txt1=paste("1st PCA component with % variance explained =",round(var1.expl))
	txt2=paste("2nd PCA component with % variance explained =",round(var2.expl))
	txt12=paste("Two component PCA % variance explained =",round(var12.expl))
	plot(proj,xlab=txt1,ylab=txt2)
	title(paste("Projection onto plane: green=genuine, red=faked\n",txt12))
	points(proj[1:100,],col=3,pch=16)
	points(proj[101:200,],col=2,pch=16)
	text(proj[,1],proj[,2],1:nrow(proj),adj=0)
}
}
