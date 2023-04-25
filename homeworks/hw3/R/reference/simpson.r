simpson <-
function(job=1)
{
dump("simpson","c:\\M7021\\simpson.r")
d=read.csv("c:\\M7021\\Simpson.csv",header=T)
x=d[,1];y=d[,2];sex=d[,3]
nW=length(sex[sex=="W"]);nM=length(sex[sex=="M"])
par(mfrow=c(1,2),mar=c(4,4,3,1),cex.main=2)
plot(x,y,xlim=c(0,100),pch=3,xlab="",ylab="",cex=1.25)
abline(lsfit(y=y,x=x),lwd=4)
title("Bad for people")
mtext(side=1,"Exercise intensity, %",line=2.75,cex=1.5)
mtext(side=2,"Body weight, lbs",line=2.75,cex=1.5)

plot(x,y,type="n",xlim=c(0,100),xlab="",ylab="")
points(x[sex=="W"],y[sex=="W"],pch=1,cex=1.25)
points(x[sex=="M"],y[sex=="M"],pch=16,cex=1.25)
title("Good for men and women")
mtext(side=1,"Exercise intensity, %",line=2.75,cex=1.5)
mtext(side=2,"Body weight, lbs",line=2.75,cex=1.5)
o=lm(BodyW~ExInt+Sex,data=d)
print(summary(o))
a=coef(o)
xx=1:100
lines(xx,a[1]+a[2]*xx,lwd=3)
lines(xx,a[1]+a[2]*xx+a[3],lwd=3,lty=2)
legend(67,154,c("Man","Woman"),pch=c(16,1),lty=1:2,lwd=3,cex=1.5,bg="gray95")
}
