library(shiny)
library(ggvis)

data(iris)
# log transform
log_feature <- log(iris[, 1:4])
target <- iris[, 5]

# apply PCA - scale. = TRUE is highly advisable, but default is FALSE.
pca <- prcomp(log_feature, center = TRUE, scale. = TRUE)
# print(pca)

server <- function(input, output) {
    output$test_here_output <- renderText({ input$test_here })
}

# library(shiny)
# library(ggvis)
# shinyServer(function(input, output, session) {
#   # A reactive subset of mtcars
#   mtc <- reactive({ mtcars[1:input$n, ] })

#   # A simple visualisation. In shiny apps, need to register observers
#   # and tell shiny where to put the controls
#   mtc %>%
#     ggvis(~wt, ~mpg) %>%
#     layer_points() %>%
#     bind_shiny("plot", "plot_ui")

#   output$mtc_table <- renderTable({
#     mtc()[, c("wt", "mpg")]
#   })
# })
