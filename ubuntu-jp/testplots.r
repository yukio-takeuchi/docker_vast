# ggplot2 pdf出力
library(tidyverse)
dat <- as_tibble(iris)

dat_long <- dat %>%
  gather(key="part", value="value",-Species) %>%
  mutate(part = as.factor(part))
p <- ggplot(dat_long, aes(x=Species, y=value, fill=Species)) +
  geom_boxplot() +
  facet_wrap(~part)

# pdfに出力
pdf("figure/iris.pdf", width=7, height=7)
print(p)
dev.off()

# 日本語を使う
p1 <- p +
  ggtitle("日本語タイトル") +
  theme(plot.title=element_text(family="Japan1GothicBBB"))
pdf("figure/iris_ja.pdf", width=7, height=7)
print(p1)
dev.off()


