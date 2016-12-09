#library(knitr)
library(tidyr)
library(dplyr)
library(moments)
library(ggplot2)
library(RColorBrewer)

# Make directory to store tables
dir.table <- "tables"
dir.create(dir.table, showWarnings=FALSE)

# Read the basic test information 
readInfo <- function(file="test_info.txt"){
  readLines(file)
}
# Format the basic test information
formatInfo <- function(x){
  y <- paste(x, collapse="；")
  y <- paste(y, "。", sep="")
  return(y)
}
test.info <- formatInfo(readInfo())

# Read and format the test score
readTest <- function(file="test_a1.csv"){
  test.raw <- read.csv(file, header=F, colClasses="character")
  # Extract and format the item information (test.item)
  test.item <- test.raw[1:5, -c(1,2)]
  row.names(test.item) <- c("item.id", "item.chapter", "item.type", "item.answer", "item.mark")
  test.item <- as.data.frame(t(test.item))
  test.item$item.mark <- as.numeric(as.character(test.item$item.mark))
  test.item$item.answer <- gsub("\\s", "", test.item$item.answer)
  test.item$item.answer <- gsub("^$", "NA", test.item$item.answer)
  test.chapter <- test.item %>% group_by(item.chapter) %>% summarise(chapter.score=sum(item.mark))
  test.type <- test.item %>% group_by(item.type) %>% summarise(type.score=sum(item.mark))
  test.item <- inner_join(test.item, test.chapter, by="item.chapter") %>% inner_join(test.type, by="item.type")
  # Extrat and format the student information (test.student)
  test.student <- as.data.frame(test.raw[-c(1:5), c(1,2)])
  colnames(test.student) <- c("student.id", "student.name")
  test.student$student.id <- as.factor(test.student$student.id)
  # Extract and format the score information (test.score)
  test.score <- test.raw[-c(2:5), -c(1,2)]
  test.score <- as.data.frame(t(test.score), stringAsFactors=FALSE)
  test.score[sapply(test.score, is.factor)] <- lapply(test.score[sapply(test.score, is.factor)], as.character)
  colnames(test.score) <- c("item.id", as.vector(test.student$student.id))
  test.score <- test.score %>% gather(student.id, student.answer, -item.id)
  test.score$item.id <- as.factor(test.score$item.id)
  test.score$student.id <- as.factor(test.score$student.id)
  test.score$student.answer <- gsub("\\s", "NA", test.score$student.answer)
  # Gather item, student, score information to one (test)
  test <- inner_join(test.score, test.student, by="student.id") %>% inner_join(test.item, by="item.id")
  test <- test %>% mutate(student.mark=ifelse(item.answer=="NA", student.answer, ifelse(student.answer==item.answer, item.mark, 0)))
  test$student.mark <- as.numeric(as.character(test$student.mark))
  test <- test %>% select(item.id, item.chapter:item.mark, chapter.score, type.score, student.id, student.name, student.answer, student.mark)
  grade <- test %>% group_by(student.id) %>% summarise(student.grade=sum(student.mark))
  grade$student.zscore <- scale(grade$student.grade)
  test <- inner_join(test, grade, by="student.id") 
  return(test)
}
test.tmp <- readTest()

# Format student grade with more information
formatGrade <- function(df=test.tmp){
  # percent.chapter <- df %>% select(item.chapter, chapter.score, student.id, student.mark) %>% group_by(student.id, item.chapter) %>% mutate(chapter.percent=sum(student.mark)/chapter.score*100) %>% select(student.id, item.chapter, chapter.percent) %>% distinct() %>% ungroup() %>% spread(item.chapter, chapter.percent)
  percent.chapter <- df %>% select(item.chapter, chapter.score, student.id, student.mark) %>% group_by(student.id, item.chapter) %>% mutate(chapter.percent=sum(student.mark)/chapter.score*100) %>% select(student.id, item.chapter, chapter.percent) %>% distinct(.keep_all = TRUE) %>% ungroup() %>% spread(item.chapter, chapter.percent)
  # percent.type <- df %>% select(item.type, type.score, student.id, student.mark) %>% group_by(student.id, item.type) %>% mutate(type.percent=sum(student.mark)/type.score*100) %>% select(student.id, item.type, type.percent) %>% distinct() %>% ungroup() %>% spread(item.type, type.percent)
  percent.type <- df %>% select(item.type, type.score, student.id, student.mark) %>% group_by(student.id, item.type) %>% mutate(type.percent=sum(student.mark)/type.score*100) %>% select(student.id, item.type, type.percent) %>% distinct(.keep_all = TRUE) %>% ungroup() %>% spread(item.type, type.percent)
  # grade <- df %>% select(student.id, student.name, student.grade, student.zscore) %>% distinct()
  grade <- df %>% select(student.id, student.name, student.grade, student.zscore) %>% distinct(.keep_all = TRUE)
  grade <- inner_join(percent.chapter, grade, by="student.id") %>% inner_join(percent.type, by="student.id")
  grade <- grade[ , c(1, c(1,2,3)+ncol(percent.chapter), seq(1,ncol(percent.chapter)-1)+1, seq(1,ncol(percent.type)-1)+ncol(percent.chapter)+3)]
  grade <- grade %>% arrange(desc(student.grade))
  write.table(format(grade, digits=4), file=paste(dir.table, "student_grade.txt", sep="/"), quote=FALSE, sep="\t", row.names=FALSE)
  number.hml <- ceiling(nrow(grade) * 0.27)
  high.id <- grade %>% arrange(student.grade) %>% tail(number.hml) %>% select(student.id) %>% mutate(grade.group="H")
  low.id <- grade %>% arrange(student.grade) %>% head(number.hml) %>% select(student.id) %>% mutate(grade.group="L")
  high.low <- rbind(high.id, low.id)
  grade <- left_join(grade, high.low, by="student.id")
  grade$grade.group <- ifelse(is.na(grade$grade.group), "M", grade$grade.group)
  test <- right_join(high.low, df, by="student.id")
  test$grade.group <- ifelse(is.na(test$grade.group), "M", test$grade.group)
  test <- test %>% select(item.id:type.score, student.id, student.name:student.zscore, grade.group)
  list.test.grade <- list("df.test"=test, "df.grade"=grade)
  return(list.test.grade) 
}
list.tg <- formatGrade(test.tmp)
test <- list.tg$df.test
grade <- list.tg$df.grade
grade.brief <- grade %>% select(student.id, student.name, student.grade, student.zscore)

# Basic summary for student grade
Mode <- function(x) {
  xtab <- table(x)
  xmode <- as.numeric(names(which(xtab == max(xtab)))) 
  if(length(xmode)>1){
    xmode <- paste(xmode,collapse=",")
  }
  return(xmode)
}
summaryGrade <- function(dfg=grade, dft=test){
  number.student <- nrow(dfg)
  number.item <- dft %>% select(item.id) %>% summarise(y=n_distinct(item.id)) %>% .$y
  # grade.total <- dft %>% select(item.id, item.mark) %>% distinct() %>% summarise(y=sum(item.mark)) %>% .$y
  grade.total <- dft %>% select(item.id, item.mark) %>% distinct(.keep_all = TRUE) %>% summarise(y=sum(item.mark)) %>% .$y
  gs <- dfg %>% summarise(gmean=mean(student.grade), gsd=sd(student.grade), gvar=var(student.grade), gmedian=median(student.grade), gmode=Mode(student.grade), gmax=max(student.grade), gmin=min(student.grade), grange=diff(range(student.grade)), gskew=skewness(student.grade), gkurt=kurtosis(student.grade))
  gs$hm <- dfg %>% filter(grade.group=="H") %>% summarise(y=mean(student.grade)) %>% .$y
  gs$mm <- dfg %>% filter(grade.group=="M") %>% summarise(y=mean(student.grade)) %>% .$y
  gs$lm <- dfg %>% filter(grade.group=="L") %>% summarise(y=mean(student.grade)) %>% .$y
  gs$pr <- dfg %>% filter(student.grade>=60) %>% summarise(y=n()/number.student*100) %>% .$y
  brief <- data.frame(number.student=number.student, number.item=number.item, grade.total=grade.total, grade.mean=gs$gmean, grade.sd=gs$gsd, grade.var=gs$gvar, grade.median=gs$gmedian, grade.mode=gs$gmode, pass.rate=gs$pr)
  detail <- data.frame(grade.max=gs$gmax, grade.min=gs$gmin, grade.range=gs$grange, grade.skewness=gs$gskew, grade.kurtosis=gs$gkurt, high.mean=gs$hm, middle.mean=gs$mm, low.mean=gs$lm)
  grade.stats <- list("brief"=brief, "detail"=detail)
  return(grade.stats)
}
list.gs <- summaryGrade(grade, test)
grade.stats.brief <- list.gs$brief
grade.stats.detail <- list.gs$detail

# Analyze test quality: Difficulty(P), Discrimination(D), Reliability(B), Validity(R), Normality(N)
calDiffi <- function(score, full){
  mean(score)/full
}
calDiscrim <- function(df, fullevel.choiceore){
  h <- df %>% filter(group=="H") %>% .$score
  l <- df %>% filter(group=="L") %>% .$score
  calDiffi(h, fullevel.choiceore) - calDiffi(l, fullevel.choiceore)
}
# Cronbach alpha
calRel <- function(df){
  item.var <- df %>% group_by(item.id) %>% summarise(y=var(student.mark)) %>% .$y
  (grade.stats.brief$number.item/(grade.stats.brief$number.item-1)) * (1-sum(item.var)/grade.stats.brief$grade.var)
}
calVal <- function(df){
  itemD <<- calItemD(df)
  d <- as.numeric(itemD$item.D)
  mean(d)
}
calItemD <- function(df){
  items <- levels(df$item.id)
  itemD <- data.frame(matrix(ncol=2, nrow=length(items)))
  colnames(itemD) <- c("item.id","item.D")
  for (i in items){
    tmp <- df %>% filter(item.id==i) %>% select(grade.group, student.mark) %>% rename(group=grade.group, score=student.mark)
    fs <- df %>% filter(item.id==i) %>% select(item.mark) %>% summarise(y=first(item.mark)) %>% .$y
    d <- calDiscrim(tmp, fs)
    #itemD <- rbind(itemD, c(i, d))
    itemD[i,] <- c(i, d)
  }
  return(itemD)
}
analyzeQuality <- function(df=grade){
  quality <- list("P"=NA, "D"=NA, "B"=NA, "R"=NA, "N"=NA)
  quality$P <- calDiffi(grade$student.grade, grade.stats.brief$grade.total)
  tmp <- df %>% select(grade.group, student.grade) %>% rename(group=grade.group, score=student.grade)
  quality$D <- calDiscrim(tmp, grade.stats.brief$grade.total)
  quality$B <- calRel(test)
  quality$R <- calVal(test)
  quality$N <- shapiro.test(df$student.grade)$p
  return(quality)
}
quality <- analyzeQuality(grade)

# Analyze the grade distribution
distributeGrade <- function(df=grade){
  df=grade
  my.breaks <- seq(0, grade.stats.brief$grade.total, by=5)
  grade.distribution <- as.data.frame(table(cut(grade$student.grade, my.breaks)))
  colnames(grade.distribution) <- c("grade.interval", "interval.count")
  grade.distribution <- grade.distribution %>% mutate(interval.percent=prop.table(interval.count), cumulative.count=cumsum(interval.count), cumulative.percent=cumsum(interval.percent))
  grade.distribution <- grade.distribution %>% filter(interval.count>0)
  write.table(format(grade.distribution, digits=4), file=paste(dir.table, "grade_distribution.txt", sep="/"), quote=FALSE, sep="\t", row.names=FALSE)
  return(grade.distribution)
}
grade.distribution <- distributeGrade(grade)

# Plot the grade distribution (hist or pie or line)
plotDistribution <- function(df=grade.distribution, type="hist"){
  my.colors <<- colorRampPalette(brewer.pal(9, "Set1"))(nrow(df))
  my.colors.sort <<- sort(my.colors)
  if(type=="hist"){
    p <- ggplot(df, aes(x=grade.interval, y=interval.count, fill=my.colors))
    p <- p + geom_bar(stat="identity", position="dodge")
    p <- p + geom_text(aes(label=interval.count, vjust=1.5))
    p <- p + theme(legend.position="none") + xlab("") + ylab("")
  }
  if(type=="pie"){
    p <- ggplot(df, aes(x="", y=interval.count, fill=my.colors.sort))
    p <- p + geom_bar(stat="identity", width=1)
    pos <<- cumsum(df$interval.count) - 0.5*df$interval.count
    lab <<- df$interval.count
    p <- p + geom_text(aes(x="", y=pos, label=lab))
    p <- p + xlab("") + ylab("")
    my.lab <<- paste(df$grade.interval, df$interval.percent, sep="\t")
    p <- p + labs(fill="") + scale_fill_manual(labels=my.lab, values=my.colors)
    p <- p + coord_polar(theta = "y")
  }
  if(type=="line"){
    p <- ggplot(df, aes(x=grade.interval, y=interval.count, group=1))
    p <- p + geom_point() + geom_line()
    p <- p + theme(legend.position="none") + xlab("") + ylab("")
  }
  return(p)
}
p.distribution <- plotDistribution(df=grade.distribution, type="hist")

# Analyze item types and chapters
analyzeType <- function(df=test){
  typeT <- df %>% select(item.id, item.type, item.mark, type.score, student.mark)%>% group_by(item.id, item.type, item.mark) %>% summarise(score.type=first(type.score), mean.item=mean(student.mark))
  typeT <- typeT %>% group_by(item.type) %>% summarise(number.type=n_distinct(item.id), score.type=first(score.type), percent.type=score.type/grade.stats.brief$grade.total, mean.type=sum(mean.item), sd.type=sd(mean.item), P.type=mean.type/score.type) %>% ungroup()
  typeT$item.type <- as.character(typeT$item.type)
  df.t <- df %>% select(item.id, item.type, item.mark, student.id, student.mark, grade.group) %>% group_by(item.type, student.id, grade.group) %>% summarise(score=sum(student.mark), mark=sum(item.mark))
  lt <- levels(df.t$item.type)
  typeD <- data.frame(matrix(ncol=2, nrow=length(lt)))
  colnames(typeD) <- c("item.type","D.type")
  for (t in lt){
    df <- df.t %>% filter(item.type==t) %>% select(grade.group, score) %>% rename(group=grade.group)
    fs <- df.t %>% filter(item.type==t) %>% summarise(y=first(mark)) %>% .$y
    d <- calDiscrim(df, fs)
    typeD <- rbind(typeD, c(t, d))
  }
  typeD <- typeD[complete.cases(typeD), ]
  typeD$D.type <- as.numeric(typeD$D.type)
  type <- inner_join(typeT, typeD, by="item.type")
  write.table(format(type, digits=4), file=paste(dir.table, "type_stats.txt", sep="/"), quote=FALSE, sep="\t", row.names=FALSE)
  return(type)
}
type <- analyzeType(test)

analyzeChapter <- function(df=test){
  chapterT <- df %>% select(item.id, item.chapter, item.mark, chapter.score, student.mark)%>% group_by(item.id, item.chapter, item.mark) %>% summarise(score.chapter=first(chapter.score), mean.item=mean(student.mark))
  chapterT <- chapterT %>% group_by(item.chapter) %>% summarise(number.chapter=n_distinct(item.id), score.chapter=first(score.chapter), percent.chapter=score.chapter/grade.stats.brief$grade.total, mean.chapter=sum(mean.item), sd.chapter=sd(mean.item), P.chapter=mean.chapter/score.chapter) %>% ungroup()
  chapterT$item.chapter <- as.character(chapterT$item.chapter)
  df.c <- df %>% select(item.id, item.chapter, item.mark, student.id, student.mark, grade.group) %>% group_by(item.chapter, student.id, grade.group) %>% summarise(score=sum(student.mark), mark=sum(item.mark))
  lt <- levels(df.c$item.chapter)
  chapterD <- data.frame(matrix(ncol=2, nrow=length(lt)))
  colnames(chapterD) <- c("item.chapter","D.chapter")
  for (t in lt){
    df <- df.c %>% filter(item.chapter==t) %>% select(grade.group, score) %>% rename(group=grade.group)
    fs <- df.c %>% filter(item.chapter==t) %>% summarise(y=first(mark)) %>% .$y
    d <- calDiscrim(df, fs)
    chapterD <- rbind(chapterD, c(t, d))
  }
  chapterD <- chapterD[complete.cases(chapterD), ]
  chapterD$D.chapter <- as.numeric(chapterD$D.chapter)
  chapter <- inner_join(chapterT, chapterD, by="item.chapter")
  write.table(format(chapter, digits=4), file=paste(dir.table, "chapter_stats.txt", sep="/"), quote=FALSE, sep="\t", row.names=FALSE)
  return(chapter)
}
chapter <- analyzeChapter(test)

# Analyze each item
analyzeItem <- function(df=test){
  itemT <- df %>% select(item.id, item.type, item.mark, item.chapter, student.mark) %>% group_by(item.id, item.type, item.chapter, item.mark) %>% summarise(item.mean=mean(student.mark), item.sd=sd(student.mark), item.P=item.mean/first(item.mark)) %>% ungroup()
  itemT$item.id <- as.character(itemT$item.id)
  itemD$item.D <- as.numeric(itemD$item.D)
  item <- inner_join(itemT, itemD, by="item.id") %>% arrange(as.numeric(item.id))
  write.table(format(item, digits=4), file=paste(dir.table, "item_stats.txt", sep="/"), quote=FALSE, sep="\t", row.names=FALSE)
  return(item)
}
item <- analyzeItem(test)

plotItem1 <- function(df=itemDP, b=my.breaks, lp=my.label.pos, lt=my.label){
  p <- ggplot(df, aes(x=item.id, y=value, linetype=PD))
  p <- p + geom_line()
  p <- p + scale_linetype_discrete(name="", limits=c("item.P", "item.D"), labels=c("P(Difficulty)", "D(Discrimination)"))
  p <- p + theme(legend.position="bottom", axis.title.x=element_blank()) + ylab("")
  p <- p + geom_vline(xintercept=b, linetype="dashed", color="red")
  p <- p + annotate("text", x=lp, y=0, label=lt, colour="red")
  return(p)
}
itemDP <- item %>% select(item.id, item.P, item.D) %>% gather("PD", "value", item.P, item.D)
itemDP$item.id <- as.numeric(itemDP$item.id)
my.breaks <- item %>% group_by(item.type) %>% summarise(y=max(as.numeric(item.id))) %>% filter(y<max(y)) %>% .$y
my.breaks <- my.breaks + 0.5
my.label.pos <- item %>% group_by(item.type) %>% summarise(y=mean(as.numeric(item.id))) %>% .$y
my.label <- levels(item$item.type)
p.item.line <- plotItem1(df=itemDP, b=my.breaks, lp=my.label.pos, lt=my.label)

plotItem.tc <- function(df){
    p <- ggplot(df, aes(x=id, y=value, linetype=PD))
    p <- p + geom_line()
    p <- p + scale_linetype_discrete(name="", limits=c("item.P", "item.D"), labels=c("P(Difficulty)", "D(Discrimination)"))
    p <- p + theme(legend.position="bottom", axis.title.x=element_blank()) + ylab("")
    p <- p + facet_wrap(~item.type, ncol=5, scales="free_x")
    return(p)
}
itemDP.type <- item %>% select(item.id, item.type, item.P, item.D) %>% group_by(item.type) %>% mutate(id=seq(1,n())) %>% ungroup() %>% gather("PD", "value", item.P, item.D)
p.item.line.type <- plotItem.tc(df=itemDP.type)
itemDP.chapter <- item %>% select(item.id, item.chapter, item.P, item.D) %>% group_by(item.chapter) %>% mutate(id=seq(1,n())) %>% ungroup() %>% gather("PD", "value", item.P, item.D)
p.item.line.chapter <- plotItem.tc(df=itemDP.chapter) %+% facet_wrap(~item.chapter, ncol=5, scales="free_x")

plotItem2 <- function(df=item, cp=cutoff.P, cd=cutoff.D){
  p <- ggplot(df, aes(x=item.P, y=item.D))
  p <- p + geom_point()
  p <- p + xlab("P(Difficulty)") + ylab("D(Discrimination)")
  p <- p + geom_text(aes(y=item.D+0.015, label=item.id))
  p <- p + geom_vline(xintercept=cp, linetype="dashed", colour="red")
  p <- p + geom_hline(yintercept=cd, linetype="dashed", colour="red")
  p <- p + annotate("text", x=cp, y=0, label=paste("P", cp, sep="="), colour="red")
  p <- p + annotate("text", x=0, y=cd+0.02, label=paste("D", cd, sep="="), colour="red")
  return(p)
}
cutoff.P <- c(0.2, 0.8)
cutoff.D=c(0.2)
p.item.point <- plotItem2(df=item, cp=cutoff.P, cd=cutoff.D)

item2check <- item %>% filter(((item.P>=cutoff.P[2] | item.P<=cutoff.P[1]) & (item.D<=cutoff.D & item.D>0)) | item.D<=0)

# Analyze single choice and multi choice
analyzeChoice <- function(df=sc, file="single_choice_stats.txt"){
  choiceT <- df %>% group_by(item.id, item.answer, item.mark) %>% summarise(choice.mean=mean(student.mark), choice.sd=sd(student.mark), choice.P=choice.mean/first(item.mark)) %>% ungroup()
  choiceT$item.id <- as.character(choiceT$item.id)
  df.choice <- df %>% select(item.id, item.mark, student.id, student.mark, grade.group) %>% group_by(item.id, student.id, grade.group) %>% summarise(score=sum(student.mark), mark=sum(item.mark))
  level.choice <- levels(df.choice$item.id)
  choiceD <- data.frame(matrix(ncol=2, nrow=length(level.choice)))
  colnames(choiceD) <- c("item.id","choice.D")
  for (t in level.choice){
    df.tmp <- df.choice %>% filter(item.id==t) %>% select(grade.group, score) %>% rename(group=grade.group)
    fs.tmp <- df.choice %>% filter(item.id==t) %>% summarise(y=first(mark)) %>% .$y
    d <- calDiscrim(df.tmp, fs.tmp)
    choiceD <- rbind(choiceD, c(t, d))
  }
  choiceD <- choiceD[complete.cases(choiceD), ]
  choiceD$choice.D <- as.numeric(choiceD$choice.D)
  choice.a <- inner_join(choiceT, choiceD, by="item.id")
  choice.a <- choice.a %>% arrange(as.numeric(item.id))
  df.passfail <- df %>% mutate(pass.fail=ifelse(student.answer==item.answer, "P", "F")) %>% select(item.id, student.id, student.grade, pass.fail)
  calRI <- function(df=df.passfail){
    pf.a <- df %>% group_by(item.id, pass.fail) %>% summarise(mean.pass=mean(student.grade)) %>% spread(pass.fail, mean.pass) %>% rename(mean.F=F, mean.P=P)
    pf.b <- df %>% group_by(item.id, pass.fail) %>% summarise(num.pass=n()) %>% spread(pass.fail, num.pass) %>% rename(num.F=F, num.P=P) %>% mutate(num.total=num.F+num.P)
    pf <- inner_join(pf.a, pf.b, by="item.id")
    pf <- pf %>% mutate(p=num.P/num.total, q=1-p)
    # sd.grade <- df %>% group_by(student.id) %>% distinct() %>% ungroup() %>% summarise(y=sd(student.grade)) %>% .$y
    sd.grade <- df %>% group_by(student.id) %>% distinct(.keep_all = TRUE) %>% ungroup() %>% summarise(y=sd(student.grade)) %>% .$y
    ri <- pf %>% mutate(choice.RPB=((mean.P-mean.F)/sd.grade)*sqrt(p*q), choice.IRI=choice.RPB*sqrt(p*q)) %>% select(item.id, choice.RPB, choice.IRI)
    ri$item.id <- as.character(ri$item.id)
    return(ri)
  }
  ri <- calRI(df.passfail)
  choice.a <- inner_join(choice.a, ri, by="item.id")
  level.answer <- sort(unique(df$student.answer))
  df.ab <- df %>% select(item.id, student.answer, student.grade) %>% group_by(item.id, student.answer) %>% summarise(percent.answer=n()/grade.stats.brief$number.student, mean.grade=mean(student.grade))
  df.a <- df.ab %>% select(item.id, student.answer, percent.answer) %>% spread(student.answer, percent.answer)
  colnames(df.a) <- c("item.id", paste("percent", level.answer, sep="."))
  df.b <- df.ab %>% select(item.id, student.answer, mean.grade) %>% spread(student.answer, mean.grade)
  colnames(df.b) <- c("item.id", paste("mean", level.answer, sep="."))
  choice.b <- inner_join(df.a, df.b, by="item.id")
  choice.b$item.id <- as.character(choice.b$item.id)
  choice.table <- inner_join(choice.a, choice.b, by="item.id")
  write.table(format(choice.table, digits=4), file=file, quote=FALSE, sep="\t", row.names=FALSE)
  return(choice.table)
}
choice <- test %>% filter(item.answer!="NA")
sc <- choice %>% filter(nchar(item.answer)==1)
if(nrow(sc)>0){
  single.choice <- analyzeChoice(df=sc, file=paste(dir.table, "single_choice_stats.txt", sep="/"))
}
mc <- choice %>% filter(nchar(item.answer)>1)
if(nrow(mc)>0){
  multi.choice <- analyzeChoice(df=mc, file=paste(dir.table, "multi_choice_stats.txt", sep="/"))
}
