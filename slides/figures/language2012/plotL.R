library(ggplot2)
library(dplyr)

l.raw <- read.table("language.txt", header=F)
colnames(l.raw) <- c("lang")

l <- l.raw %>% group_by(lang) %>% summarise(count=n())
ls <- l %>% filter(count>=20) %>% arrange(desc(count))

p <- ggplot(ls, aes(x=reorder(lang, -count), y=count, fill=lang))
p <- p + geom_bar(stat="identity")
p <- p + theme_gray(base_size=20)
p <- p + labs(x="", y="")
p <- p + theme(legend.position="none", axis.text=element_text(colour="black"))

ggsave("language.png", plot=p, width=12)
