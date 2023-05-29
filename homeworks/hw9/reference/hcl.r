hcl <-
function(n=9,dm=2,distmeth=1,ss=3)
{
#n=the number of points in each cluster
#dm=the difference in the means
#dismeth - distance between vectors: 1=euclidean (L2), 2=maximum (L1), 3=manhattan (Linf)
#ss=simulation seed number

    dump("hcl","c:\\M7021\\hcl.r")
    set.seed(ss)
    namd=c("euclidean", "maximum", "manhattan", "canberra", "binary","minkowski") 
    par(mfrow=c(2,3),mar=c(1,4,3,1),omi=c(0,0,.1,0))
    X1=matrix(rnorm(2*n),ncol=2,nrow=n)
    X2=matrix(rnorm(2*n,mean=dm),ncol=2,nrow=n)
    X=rbind(X1,X2)
    d=dist(X,method=namd[distmeth])
    plot(X[,1],X[,2],main="Data points",type="n",axes=F,xlab="",ylab="")
    text(X[,1],X[,2],1:(2*n),font=2,cex=2,col=c(rep(2,n),rep(3,n)))
	#distance between clusters
    meth=c("ward.D", "ward.D2", "single", "complete", "average")
    for(i in 1:5)
    {
		o=hclust(d,method=meth[i])
		plot(o,main=meth[i],sub="",cex=2,lwd=3)
    }
    mtext(side=3,namd[distmeth],cex=1.5,outer=T,line=-1)
}
