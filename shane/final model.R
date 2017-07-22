dat=read.csv(file = "Taipei_land.csv", fileEncoding ="big5")[,-29]
dat1=dat[-which(dat$�`����==0 | dat$�ت���==0 | dat$�`����==dat$�����`����),]  #�S������B,������
dat1=dat1[-c(which(dat$�`����<10000),1:2),]
dat1=dat1[-which(grepl("��",as.character(dat1$�Ƶ�))),]

dat2=dat1[-union(which(is.na(dat1$����C���褽��)),which(dat1$�h�h==1 & dat1$�ت����A!="�z�ѭ�")),]

money=dat2$�`����-dat2$�����`����
time=as.numeric(as.POSIXct(as.character(dat2$����~���)))
mm=money/dat2$�ت������`���n���褽��
dat3=cbind(dat2,time,mm)
dat3$top=ifelse(dat3$�Ӽh==dat3$�`�Ӽh��,1,0)
dat3$�Ӽh=as.factor(dat3$�Ӽh)
dat3$�`�Ӽh��=as.factor(dat3$�`�Ӽh��)

dat4=dat3[which(dat3$�D�n�γ~%in%c("���a��","���ӥ�","������v")),]
dat4=dat4[,c(1,5,9,10,11,12,14,29:31)]

train=dat4[which(dat4$time<as.numeric(as.POSIXct("2017/1/1"))),]
test=dat4[which(dat4$time>=as.numeric(as.POSIXct("2017/1/1"))),]
## random forest
library("randomForest")
rm(dat);rm(dat1);rm(dat2);rm(dat3);rm(dat4);rm(mm);rm(money);rm(time)
gc()
model=randomForest(mm~.,dat=train)
# mean(abs(test$mm-predict(fit,test)))
# mean(abs(test$mm-mean(test$mm)))



final.model=function(model=model,dat){
    # dat <- test
    
    dat$time=as.numeric(Sys.time())
    dat$top=ifelse(dat$�Ӽh==dat$�`�Ӽh��,1,0)
    dat$�D�n�γ~= factor(x=c("���a��"), levels = levels(train$�D�n�γ~))
    dat$����=as.numeric(as.character(dat$����))
    dat$�Ӽh= factor(dat$�Ӽh, levels = train$�Ӽh %>% levels)
    dat$�`�Ӽh��= factor(dat$�`�Ӽh��,levels = train$�`�Ӽh�� %>% levels )
    dat$�ت������`���n���褽��=as.numeric(as.character(dat$�ت������`���n���褽��))
    result=predict(model,dat)
    return(result)
}