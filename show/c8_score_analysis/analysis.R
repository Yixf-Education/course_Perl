library(readr)
library(tidyr)
library(dplyr)
library(stringr)
library(ggplot2)
#library(broom)
library(ComplexHeatmap)
library(circlize)

# Read data for 2013, and tranform it
score_wide <- read_csv("score_2013.csv")
score_long <- gather(score_wide, "class", "score", 3:7)
score_long <- score_long %>% mutate(id2=as.factor(str_replace(id, "20130521", "")))

# Comparation between experiments
score_long2 <- score_long %>% filter(str_detect(class, "e"))
gb <- ggplot(score_long2, aes(class, score))
gb <- gb + geom_boxplot(aes(fill=class, color=class), alpha=0.5)
ggsave("exp_boxplot.png", gb)
gv <- ggplot(score_long2, aes(class, score))
gv <- gv + geom_violin(aes(fill=class, color=class), alpha=0.2)
gv <- gv + geom_boxplot(aes(fill=class, color=class), width=0.1)
gv <- gv + stat_summary(fun.y="mean", geom="point", shape=23, size=3, fill="red")
gv <- gv + stat_summary(fun.y="median", geom="point", shape=21, size=3, fill="blue")
gv <- gv + geom_dotplot(binaxis="y", binwidth=0.3, stackdir="center", fill=NA)
ggsave("exp_violin.png", gv)

tri2mat <- function(tp, pf) {
  tp <- cbind(tp, rep(NA, nrow(tp)))
  tp <- rbind(rep(NA, ncol(tp)), tp)
  colnames(tp) <- pf
  rownames(tp) <- pf
  tp[upper.tri(tp)] <- t(tp)[upper.tri(tp)]
  #diag(tp) <- 1
  tp
}

# Heatmap p.value bwteen experiments
t_test <- pairwise.t.test(score_long2$score, score_long2$class, p.adjust.method="none", pool.sd=FALSE)
tp <- t_test$p.value
pf <- levels(as.factor(score_long2$class))
tm <- tri2mat(tp, pf)
col = colorRamp2(seq(min(tm, na.rm=TRUE), max(tm, na.rm=TRUE), length=3), c("red", "#EEEEEE", "blue"), space="RGB")
png("exp_heatmap.png", width=1024, height=960, res=200)
Heatmap(tm, col=col, heatmap_legend_param=list(title="p.value"),
        cluster_rows=FALSE, cluster_columns=FALSE)
dev.off()

# Line each student for experiments
gl <- ggplot(score_long2, aes(class, score, group=id2))
gl <- gl + geom_point()
gl <- gl + geom_line(aes(color=id2))
ggsave("id_lineplot.png", gl)

lm_eqn <- function(df) {
  m <- lm(final ~ exp, df)
  eq <- substitute(italic(y) == a + b %.% italic(x) *","* ~~italic(r)~"="~r1 *","* ~~italic(R)^2~"="~r2, 
                   list(a = format(coef(m)[1], digits=2), 
                        b = format(coef(m)[2], digits=2), 
                        r1 = format(sqrt(summary(m)$r.squared), digits=3),
                        r2 = format(summary(m)$r.squared, digits=3)))
  as.character(as.expression(eq))
}

plot_cor <- function (df){
  gr <- ggplot(df, aes(exp, final))
  gr <- gr + geom_point()
  gr <- gr + geom_smooth(method="lm", color="red", formula=y~x)
  gr <- gr + geom_text(x=82, y=100, label=lm_eqn(df), parse=TRUE, size=5, color="blue")
}

# Correlation between experiments and final exam
score_wide2 <- score_wide %>% group_by(id,name,final) %>% summarise(exp=mean(c(e6,e7,e8,e9))) 
#score_exp <- score_long %>% filter(str_detect(class, "e")) %>% group_by(id,name) %>% summarise(exp=mean(score))
#score_final <- score_long %>% filter(str_detect(class, "final")) %>% group_by(id,name) %>% summarise(final=score)
#score_wide2 <- inner_join(score_exp, score_final)
gr <- plot_cor(score_wide2)
ggsave("correlation_plot.png", gr)

id1 <- score_wide2[which.min(score_wide2$final),]$id
score_wide3 <- score_wide2 %>% filter(id!=id1)
#score_wide3 <- score_wide2 %>% filter(id!="2013052125")
gr2 <- plot_cor(score_wide3)
ggsave("correlation_plot_correct.png", gr2)

m <- lm(final ~ exp, score_wide3)
score2014 <- read_csv("score_2014.csv")
mp <- predict(m, score2014, interval="prediction")
s4 <- bind_cols(score2014, as.data.frame(mp))
colnames(s4) <- c("ID", "name", "exp", "final", "fl", "fu")
s4 <- s4 %>% mutate(id=as.factor(str_replace(ID, "20140521", "")))
g <- ggplot(s4, aes(x=id, y=final, fill=id))
g <- g + theme_gray(base_size=18)
g <- g + geom_bar(stat="identity")
g <- g + geom_errorbar(aes(ymin=fl, ymax=fu), width=0.2)
g <- g + geom_hline(yintercept=60, color="red", size=1.5)
g <- g + geom_hline(yintercept=c(50, 70, 80, 90), color=c("red", "yellow", "green", "blue"), size=0.5, linetype=2)
g <- g + scale_y_continuous(breaks=c(0, 30, seq(50,100,10)))
g <- g + labs(x="Student ID", y="Predicted final exam score")
g <- g + guides(fill=FALSE)
ggsave("prediction_2014.png", g, width=10, height=5)
