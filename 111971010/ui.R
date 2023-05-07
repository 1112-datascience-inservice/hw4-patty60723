# shinyUI(pageWithSidebar(
#     div(),
#     sidebarPanel(
#         sliderInput("n", "Number of points",
#             min = 1, max = nrow(mtcars),
#             value = 10, step = 1
#         ),
#         uiOutput("plot_ui")
#     ),
#     mainPanel(
#         ggvisOutput("plot"),
#         tableOutput("mtc_table")
#     )
# ))
library(ggvis)
# [layout reference](https://codepen.io/dodozhang21/pen/kMoXZz)
ui <- fluidPage(
    titlePanel("PCA of Iris data"),
    tags$head(
        list(
            tags$link(
                rel = "stylesheet",
                type = "text/css", href = "style.css"
            ),
            tags$link(
                rel = "stylesheet",
                href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
            )
        )
    ),
    div(
        class = "container",
        div(
            class = "st-container",
            list(
                HTML(
                    '<input type="radio" name="radio-set"
            checked="checked" id="st-control-1"/>
    <a href="#st-panel-1">Iris Data</a>
    <input type="radio" name="radio-set" id="st-control-2"/>
    <a href="#st-panel-2">Statics</a>
    <input type="radio" name="radio-set" id="st-control-3"/>
    <a href="#st-panel-3">PCA</a>
    <input type="radio" name="radio-set" id="st-control-4"/>
    <a href="#st-panel-4">CA</a>'
                ),
                div(
                    class = "st-scroll",
                    list(
                        HTML(
                            '<section class="st-panel" id="st-panel-1">
                        <div class="st-deco" data-icon="&#xf069;"></div>
                        <h2>Iris Data</h2>
                        <div class="st-content">
                            <input type="text" name="test_here" id="test_here">
                            <p></p>'
                        ), tags$div(htmlOutput("test_here_output")),
                        HTML("
                        </div>
                    </section>")
                    )
                ),
                div(
                    class = "st-scroll",
                    HTML('<section class="st-panel st-color" id="st-panel-2">
                        <div class="st-deco" data-icon="&#xf069;"></div>
                        <h2>Statics</h2>
                        <p></p>
                    </section>')
                ),
                div(
                    class = "st-scroll",
                    HTML('<section class="st-panel" id="st-panel-3">
                        <div class="st-deco" data-icon="&#xf069;"></div>
                        <h2>PCA</h2>
                        <p></p>
                    </section>')
                ),
                div(
                    class = "st-scroll",
                    HTML('<section class="st-panel st-color" id="st-panel-4">
                        <div class="st-deco" data-icon="&#xf069;"></div>
                        <h2>CA</h2>
                        <p></p>
                    </section>')
                )
            )
        )
    )
)
