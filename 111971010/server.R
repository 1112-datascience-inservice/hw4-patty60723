library("FactoMineR")
library("factoextra")
library(dplyr)
library(tidyr)
library(shiny)
library(ggvis)
library(xtable)
library(DT)

data(iris)

# log transform
log_feature <- log(iris[, 1:4])
target <- iris[, 5]
pca <- PCA(log_feature, graph = FALSE)
ca <- CA(iris[, 1:4], graph = FALSE)

data_summary <- iris[, 1:4] %>%
    summarise_all(
        list(
            Min = min,
            "1st Qu." = ~ quantile(.x, c(0.25)),
            Mean = mean,
            Median = median,
            "3rd Qu." = ~ quantile(.x, c(0.75)),
            Max = max
        ),
    ) %>%
    pivot_longer(
        cols = everything(),
        names_to = c(".value", " "), names_sep = "_"
    )

by_species <- iris %>%
    group_by(Species) %>%
    summarise(Count = n())

server <- function(input, output) {
    x_pca <- NULL
    y_pca <- NULL

    x_pca <- reactive({
        input$x_button
    })

    y_pca <- reactive({
        input$y_button
    })

    output$var_pca <- renderPlot({
        if (!is.null(x_pca()) && !is.null(y_pca())) {
            fviz_pca_var(pca,
                col.var = "cos2",
                axes = c(as.integer(x_pca()), as.integer(y_pca())),
                gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                repel = TRUE # Avoid text overlapping
            )
        }
    })

    output$ind_pca <- renderPlot({
        if (!is.null(x_pca()) && !is.null(y_pca())) {
            fviz_pca_biplot(pca,
                axes = c(as.integer(x_pca()), as.integer(y_pca())),
                # Individuals
                geom.ind = "point",
                fill.ind = iris$Species,
                col.ind = "grey",
                pointshape = 21,
                pointsize = 2,
                palette = "jco",
                addEllipses = TRUE,
                # Variables
                alpha.var = "contrib",
                col.var = "contrib",
                gradient.cols = "RdYlBu",
                legend.title = list(
                    fill = "Species", color = "Contrib",
                    alpha = "Contrib"
                ),
                repel = TRUE # Avoid text overlapping
            )
        }
    })

    output$contrib <- renderPlot({
        if (!is.null(x_pca()) && !is.null(y_pca())) {
            fviz_contrib(pca, choice = "var", c(as.integer(x_pca()), as.integer(y_pca())))
        }
    })

    output$ca <- renderPlot({
        fviz_ca_biplot(ca, map = "colgreen", arrow = c(TRUE, FALSE), repel = TRUE)
    })

    # panel1
    output$iris_table <- renderPrint({
        print(xtable(as.data.frame(data_summary)), type = "html")
    })

    output$iris_species_table <- renderPrint({
        print(xtable(as.data.frame(by_species)), type = "html")
    })

    output$dt_table <- renderDT({
        datatable(
            iris,
            selection = "none",
            extensions = "KeyTable",
            options = list(
                keys = TRUE
            )
        )
    })
}
