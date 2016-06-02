library(ggplot2)

s <- read.table("similar.txt", header=F)
colnames(s) <- c("percent")

s$percent <- s$percent * 100

t <- t.test(s$percent, mu=25)
tp <- round(t$p.value, digits=3)

binsize <- diff(range(s$percent))/50

p <- ggplot(s, aes(x=percent, y=..density..))
p <- p + geom_histogram(binwidth=binsize, fill="cornsilk", colour="grey60")
p <- p + geom_density(colour=NA)
p <- p + geom_line(stat="density")
p <- p + geom_vline(xintercept=25, colour="red")
p <- p + annotate("text", x=25.04, y=6.8, label=paste("p=", tp, sep=""), family="serif", fontface="italic", colour="darkred", size=8)
p <- p + theme_gray(base_size=20)
p <- p + labs(x="Average % identity between pairs of random DNA sequences", y="Density")
p

ggsave("similar.png", plot=p, width=10)
