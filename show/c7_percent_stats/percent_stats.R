library(readr)
library(dplyr)
library(ggplot2)

percent <- read_tsv("percents.txt", col_names=FALSE)
percent <- percent %>% rename(perc=X1)

t <- t.test(percent$perc, mu=25)
formula <- sprintf("italic(p) == %.4f", round(t$p.value, 4))

p <- ggplot(percent, aes(x=perc, y=..density..))
p <- p + geom_histogram(fill="cornsilk", color="grey60")
p <- p + geom_density()
p <- p + theme_gray(base_size=20)
p <- p + labs(x="Average % identity between pairs of random DNA sequences", y="Density")
p <- p + geom_vline(xintercept=25, color="red")
p <- p + annotate("text", x=26, y=0.3, label=formula, parse=TRUE, color="darkred", size=6)
ggsave("percent_density.png", p, width=10)

