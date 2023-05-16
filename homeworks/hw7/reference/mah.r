mah <-
function(job=1,n1=1000,n2=2000,mu1=c(2,2),mu2=c(3,4),sd1=1.5,sd2=2,ro=-.4,ss=3)
{
dump("mah","c:\\M7021\\mah.r")
set.seed(ss)
if(job==0)
{
	N=200
	Omega=matrix(c(sd1^2,sd1*sd2*ro,sd1*sd2*ro,sd2^2),2,2)
	z1=seq(from=mu1[1]-2*sd1,to=mu1[1]+2*sd1,length=N)
	z2=seq(from=mu1[2]-3*sd2,to=mu1[2]+3*sd2,length=N)
	dens=matrix(ncol=N,nrow=N)
	cof=1/(2*pi)/sd1/sd2/sqrt(1-ro^2)
	for(i in 1:N)
	for(j in 1:N)
		dens[i,j]=1/2/(1-ro^2)*(((z1[i]-mu1[1])/sd1)^2-2*ro*(z1[i]-mu1[1])/sd1*(z2[j]-mu1[2])/sd2+((z2[j]-mu1[2])/sd2)^2)
	dens=cof*exp(-dens)
	contour(z1,z2,dens,col=2,xlim=c(-1,6),ylim=c(-1,6))
	z1=seq(from=mu2[1]-2*sd1,to=mu2[1]+2*sd1,length=N)
	z2=seq(from=mu2[2]-2*sd2,to=mu2[2]+2*sd2,length=N)
	dens=matrix(ncol=N,nrow=N)
	cof=1/(2*pi)/sd1/sd2/sqrt(1-ro^2)
	for(i in 1:N)
	for(j in 1:N)
		dens[i,j]=1/2/(1-ro^2)*(((z1[i]-mu2[1])/sd1)^2-2*ro*(z1[i]-mu2[1])/sd1*(z2[j]-mu2[2])/sd2+((z2[j]-mu2[2])/sd2)^2)
	dens=cof*exp(-dens)
	contour(z1,z2,dens,col=3,add=T)
	segments(mu1[1],mu1[2],mu2[1],mu2[2],lwd=3)
	av=(mu1+mu2)/2
	points(av[1],av[2],pch=1,cex=2)
	n=solve(Omega)%*%(mu1-mu2)
	arrows(av[1],av[2],av[1]+n[1],av[2]+n[2],lwd=2,col=2)
	x=seq(from=-1,to=6,length=200)
	y=av[2]-n[1]/n[2]*(x-av[1])
	lines(x,y,lwd=3,col=4)
	legend("topleft",c("Arrow: vector n","Blue line: LDA rule"),col=c(2,4),lwd=3,lty=1,cex=1.5,bg="grey95")
	
	
}
if(job==1) #illustration of LDA
{	
	par(mfrow=c(1,1),mar=c(4,4,4,1))
    Omega=matrix(c(sd1^2,sd1*sd2*ro,sd1*sd2*ro,sd2^2),2,2)
    co=chol(Omega)
    p1=cbind(rnorm(n1),rnorm(n1))
	p1=p1%*%co+rep(1,n1)%*%t(mu1)
    p2=cbind(rnorm(n2),rnorm(n2))
    p2=p2%*%co+rep(1,n2)%*%t(mu2)
    p12=rbind(p1,p2)
    plot(p12,type="n",xlab="x",ylab="y")
    points(p1[,1],p1[,2],col=2)
    points(mu1[1],mu1[2],pch=3,cex=4)
    points(p2[,1],p2[,2],col=3)
    points(mu2[1],mu2[2],pch=3,cex=4)
    z=seq(from=0,to=1,length=100)
    lines(mu1[1]*z+mu2[1]*(1-z),mu1[2]*z+mu2[2]*(1-z))
    a=solve(Omega)%*%(mu1-mu2)
    x=seq(from=-100,to=100,length=100)
    ma=(mu1+mu2)/2
    y=ma[2]-a[1]/a[2]*(x-ma[1])
    lines(x,y,lwd=3)
    i1=1:n1;i2=1:n2
    ind=1:(n1+n2);memb=c(rep(1,n1),rep(2,n2))
    classR=(p12-rep(1,n1+n2)%*%t(ma))%*%a
    #IFer=(classR<0 & memb==1) | (classR>0 & memb==2)
	IFer=sum(classR<0 & memb==1)
    EmpErr=IFer/n1
    delta2=t(mu1-mu2)%*%solve(Omega)%*%(mu1-mu2)
    TheorErr=pnorm(-sqrt(delta2)/2)
    title(paste("Fisher LDA for classification, the total error of misclassification =",round(2*TheorErr,3),"\nEmpirical 1st cluster miscl prob =",round(EmpErr,4),", theoretical 1st cluster miscl error =",round(TheorErr,4)))
}
if(job==2) #ROC curve
{
	par(mfrow=c(1,1),mar=c(4.5,4.5,4,1),cex.lab=1.5,cex.main=1.5)
    Omega=matrix(c(sd1^2,sd1*sd2*ro,sd1*sd2*ro,sd2^2),2,2)
    co=chol(Omega)
    p1=cbind(rnorm(n1),rnorm(n1))
	p1=p1%*%co+rep(1,n1)%*%t(mu1)
    p2=cbind(rnorm(n2),rnorm(n2))
    p2=p2%*%co+rep(1,n2)%*%t(mu2)
    p12=rbind(p1,p2)
	memb=c(rep(1,n1),rep(2,n2))
	a=solve(Omega)%*%(mu1-mu2)
    ma=(mu1+mu2)/2
    classR=(p12-rep(1,n1+n2)%*%t(ma))%*%a
    #IFer=(classR<0 & memb==1) | (classR>0 & memb==2)
	n=n1+n2
	sens=fp=rep(0,n)
	s.classR=sort(classR)
	AUC=0
	for(i in 1:n)
	{
		sens[i]=sum(classR>s.classR[i] & memb==1)/sum(memb==1)
		fp[i]=sum(classR>s.classR[i] & memb==2)/sum(memb==2)	
		if(i>1) AUC=AUC+(fp[i-1]-fp[i])*sens[i]
	}
	delta=sqrt(sum(a*(mu1-mu2)))
	plot(fp,sens,type="s",lwd=3,xlab="False positive rate",ylab="Sensitivity",main="ROC curve for the LDA classification")
	text(.4,.4,paste("Empirical AUC = ",round(100*AUC,1),"%",cex=""),cex=1.5,adj=0,font=3)
	text(.4,.35,paste("Binormal AUC = ",round(100*pnorm(delta/sqrt(2)),1),"%",cex=""),cex=1.5,adj=0,font=3)
	legend("bottomright",c("Empirical ROC curve","Binormal ROC curve"),col=1:2,lwd=c(3,1),cex=1.25)
	u=seq(from=delta^2/2-4*delta,to=delta^2/2+4*delta,length=1000)
	lines(pnorm((u-delta^2/2)/delta),pnorm((u+delta^2/2)/delta),col=2)

}	
}
