library("FactoMineR")
library("factoextra")
library(dplyr)
library(tidyr)
library(shiny)
library(ggvis)
library(ggplot2)
library(reshape2)
library(xtable)
library(DT)

data(iris)

server <- function(input, output) {
    x_pca <- NULL
    y_pca <- NULL
    slider_sample <- NULL

    x_pca <- reactive({
        input$x_button
    })

    y_pca <- reactive({
        input$y_button
    })

    slider_sample <- reactive({
        input$sample_n_input
    })

    seed_num <- reactive({
        set.seed(input$seed_setting)
        input$seed_setting
    })

    sample_iris <- reactive({
        iris[sample(nrow(iris), input$sample_n_input, replace = FALSE), ]
    })

    pca <- reactive({
        set.seed(input$seed_setting)
        PCA(log(iris[sample(nrow(iris), input$sample_n_input, replace = FALSE), ][, 1:4]), graph = FALSE)
    })

    ca <- reactive({
        set.seed(input$seed_setting)
        CA(iris[sample(nrow(iris), input$sample_n_input, replace = FALSE), ][, 1:4], graph = FALSE)
    })

    output$seed_num <- renderText({
        seed_num()
    })

    output$var_pca <- renderPlot({
        if (!is.null(x_pca()) && !is.null(y_pca())) {
            fviz_pca_var(pca(),
                col.var = "cos2",
                axes = c(as.integer(x_pca()), as.integer(y_pca())),
                gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                repel = TRUE # Avoid text overlapping
            )
        }
    })

    output$x_pca_name <- renderText({
        if (!is.null(x_pca()) && !is.null(y_pca())) {
            switch(x_pca(),
            "1" = "PCA1",
            "2" = "PCA2",
            "3" = "PCA3",
            "4" = "PCA4",
            "尚未於前一頁選擇")
        } else {
            "尚未於前一頁選擇"
        }
    })

    output$y_pca_name <- renderText({
        if (!is.null(x_pca()) && !is.null(y_pca())) {
            switch(y_pca(),
            "1" = "PCA1",
            "2" = "PCA2",
            "3" = "PCA3",
            "4" = "PCA4",
            "尚未於前一頁選擇")
        } else {
            "尚未於前一頁選擇"
        }
    })

    output$sample_n <- renderText({
        slider_sample()
    })

    output$eig_panel <- renderPrint({
        cat("<h3>Eigenvalues and Plot</h3>")
        print(xtable(as.data.frame(get_eigenvalue(pca()))), type = "html")
    })

    output$eig_plot <- renderPlot({
        fviz_eig(pca(), addlabels = TRUE, ylim = c(0, 100))
    })

    output$eig_panel_ca <- renderPrint({
        cat("<h3>Eigenvalues and Plot</h3>")
        print(xtable(as.data.frame(ca()$eig)), type = "html")
    })

    output$eig_plot_ca <- renderPlot({
        fviz_screeplot(ca(), addlabels = TRUE, ylim = c(0, 100))
    })

    output$ind_pca <- renderPlot({
        if (!is.null(x_pca()) && !is.null(y_pca())) {
            fviz_pca_biplot(pca(),
                axes = c(as.integer(x_pca()), as.integer(y_pca())),
                # Individuals
                geom.ind = "point",
                fill.ind = sample_iris()$Species,
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
            fviz_contrib(pca(), choice = "var", c(as.integer(x_pca()), as.integer(y_pca())))
        }
    })

    output$pca_table <- renderPrint({
        var <- get_pca_var(pca())
        cat("<h3>Contributions of the variables</h3>")
        print(xtable(as.data.frame((var$contrib))), type = "html")
        cat("<h3>Correlations variables - demensions</h3>")
        print(xtable(as.data.frame((var$cor))), type = "html")
        cat("<h3>cos2 for the variables</h3>")
        print(xtable(as.data.frame((var$cos2))), type = "html")
        cat("<h3>coord. for the variables</h3>")
        print(xtable(as.data.frame((var$coord))), type = "html")
    })

    output$ca <- renderPlot({
        fviz_ca_biplot(ca(), map = "colgreen", arrow = c(TRUE, FALSE), repel = TRUE)
    })

    output$iris_table <- renderPrint({
        set.seed(seed_num())
        print(xtable(as.data.frame(
            iris[sample(nrow(iris), slider_sample(), replace = FALSE), ][, 1:4] %>%
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
        )), type = "html")
    })

    output$iris_species_table <- renderPrint({
        set.seed(seed_num())
        print(xtable(as.data.frame(
            sample_iris() %>%
                group_by(Species) %>%
                dplyr::summarize(count = n())
        )), type = "html")
    })

    output$dt_table <- renderDT({
        set.seed(seed_num())
        datatable(
            iris[sample(nrow(iris), slider_sample(), replace = FALSE), ],
            selection = "none",
            extensions = "KeyTable",
            options = list(
                keys = TRUE
            )
        )
    })

    output$heatmap <- renderPlot({
        melted_iris <- melt(iris[sample(nrow(iris), slider_sample(), replace = FALSE), ],)
        ggplot(data = melted_iris, aes(x = variable, y = Species, fill = value)) + 
        geom_tile()
    })
}
