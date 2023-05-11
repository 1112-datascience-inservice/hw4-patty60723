data(iris)
# log transform
log.ir <- log(iris[, 1:4])
ir.species <- iris[, 5]
# apply PCA - scale. = TRUE is highly advisable, but default is FALSE.
ir.pca <- prcomp(log.ir, center = TRUE, scale. = TRUE)
library(ggbiplot)
g <- ggbiplot(ir.pca, obs.scale = 1, var.scale = 1, groups = ir.species, choices = 1:2)
g <- g + scale_color_discrete(name = "")
g <- g + theme(legend.direction = "horizontal", legend.position = "top")

print(g)
install.packages("FactoMineR")
library("FactoMineR")
install.packages("factoextra")
library("factoextra")
summary(iris)
res.pca <- PCA(log.ir, graph = FALSE)
test <- fviz_pca_ind(res.pca,
    geom.ind = "point",
    label = "none", # hide individual labels
    habillage = iris$Species, # color by groups
    palette = c("#00AFBB", "#E7B800", "#FC4E07"),
    addEllipses = TRUE # Concentration ellipses
)
ggsave("./test.png", width = 5, height = 5)
fviz_contrib(res.pca, choice = "var", axes = 2, top = 4)


res_ca <- CA(log.ir, graph = FALSE)
get_ca_row(res_ca)
get_ca_col(res_ca)
fviz_ca_biplot(res_ca, repel = TRUE)

data(iris)
# set.seed(1233)
# head(iris[sample(nrow(iris), 5, replace = FALSE), ][, 1:4])
chisq <- chisq.test(iris[, 1:4])
chisq
chisq$statistic
chisq$parameter

prcomp(iris[, 1:4])
p <- PCA(iris[, 1:4], graph = FALSE)
p$centre


q <- prcomp(iris[, 1:4])
ca <- CA(iris[, 1:4], graph = FALSE)
