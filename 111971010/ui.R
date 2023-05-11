library(ggvis)
library(DT)
library(htmlwidgets)

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
            ),
            tags$script(
                src = "index.js"
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
    <a href="#st-panel-2">PCA Table</a>
    <input type="radio" name="radio-set" id="st-control-3"/>
    <a href="#st-panel-3">PCA Graph</a>
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
                            <div class="left-panel text-center">
                                <h3> Iris </h3>
                        '
                        ), tags$img(src = "iris_exp.jpg"),
                        HTML('
                                <h3>隨機挑選樣本</h3>
                                <div id="random_buttons">
                                    <div class="text-center">種子: '), htmlOutput("seed_num"), HTML('</div>
                                    <button id="refresh" type="button" class="text-darkgreen">隨機產生</button>
                                    <div class="text-center" style="display: inline-block">
                                        或自行設定<br>
                                        <input type="text" id="seed_setting" class="postlink text-darkgreen" value="357">
                                        '), htmlOutput("testtest", class = "text-darkgreen"), HTML('
                                    </div>
                                </div>
                                <h3>選擇 Sample 的數量</h3>
                                <div class="text-center">Sample 數量: '), htmlOutput("sample_n"), HTML('</div>
                                <div class="slider-container">
                                    <div class="slider con-tooltip bottom">
                                        <input type="range" min="6" max="150" value="150" id="slider">
                                        <div class="tooltip">
                                            <span id="tooltip_silder_num">150</span>
                                        </div>
                                    </div>
                                    <div class="form-group shiny-input-container">
                                        <input id="sample_n_input" type="text" class="form-control shiny-bound-input" value="150" style="display: none">
                                    </div>
                                </div>
                            </div>
                            <div class="right-panel text-center">
                                <h3>Summary</h3>
                        '), tags$div(list(htmlOutput("iris_table"), htmlOutput("iris_species_table"))),
                        HTML("
                                <h3>Raw Data</h3>
                            "), DTOutput("dt_table"),
                        HTML("
                            </div>
                        </div>
                    </section>")
                    )
                ),
                div(
                    class = "st-scroll",
                    list(
                        HTML(
                            '<section class="st-panel st-color" id="st-panel-2">
                                <div class="st-deco" data-icon="&#xf069;"></div>
                                <h2>PCA table</h2>
                                <div class="st-content">
                                    <div class="right-panel text-center">
                                '), htmlOutput("pca_table", class = "text-white"), htmlOutput("eig_panel", class = "text-white"), 
                                HTML('<div class="w50">')
                                    , plotOutput("eig_plot"),
                                HTML('</div>
                                    </div>
                                </div>
                            </section>')
                            )
                ),
                div(
                    class = "st-scroll",
                    list(
                        HTML(
                            '<section class="st-panel" id="st-panel-3">
                                <div class="st-deco" data-icon="&#xf069;"></div>
                                <h2>PCA Graph</h2>
                                <div class="st-content">
                                    <div class="left-panel text-center">
                                        <h3>選擇 PCA 的 X 軸與 Y 軸</h3>
                                        <div class="text-center text-white">X軸</div>
                                        <div class="button-group shiny-input-radiogroup" id="x_button">
                                            <label class="button"><input id="x_pca1" type="radio" name="x_button" style="display: none" value="1" data-rel="y_button">PCA1</label>
                                            <label class="button"><input id="x_pca2" type="radio" name="x_button" style="display: none" value="2" data-rel="y_button">PCA2</label>
                                            <label class="button"><input id="x_pca3" type="radio" name="x_button" style="display: none" value="3" data-rel="y_button">PCA3</label>
                                            <label class="button"><input id="x_pca4" type="radio" name="x_button" style="display: none" value="4" data-rel="y_button">PCA4</label>
                                        </div>
                                        <div class="text-center text-white">Y軸</div>
                                        <div class="button-group shiny-input-radiogroup" id="y_button">
                                            <label class="button"><input id="y_pca1" type="radio" name="y_button" style="display: none" value="1" data-rel="x_button">PCA1</label>
                                            <label class="button"><input id="y_pca2" type="radio" name="y_button" style="display: none" value="2" data-rel="x_button">PCA2</label>
                                            <label class="button"><input id="y_pca3" type="radio" name="y_button" style="display: none" value="3" data-rel="x_button">PCA3</label>
                                            <label class="button"><input id="y_pca4" type="radio" name="y_button" style="display: none" value="4" data-rel="x_button">PCA4</label>
                                        </div>
                                    </div>
                            <div class="right-panel">
                            '), tags$div(plotOutput("var_pca")), tags$div(plotOutput("ind_pca")), tags$div(plotOutput("contrib")),
                        HTML("
                            </div>
                        </div>
                    </section>")
                    )
                ),
                div(
                    class = "st-scroll",
                    list(HTML('<section class="st-panel st-color" id="st-panel-4">
                        <div class="st-deco" data-icon="&#xf069;"></div>
                        <h2>CA</h2>
                        <div class="st-content">
                            <div class="right-panel text-center">
                            '), tags$div(plotOutput("ca")),
                                HTML('<h3>Correlation Heatmap</h3>'),
                                tags$div(plotOutput("heatmap"), class = "w50"), htmlOutput("eig_panel_ca", class = "text-white"), 
                                HTML('<div class="w50">')
                                    , plotOutput("eig_plot_ca"),
                                HTML("</div>
                            </div>
                        </div>
                    </section>"))
                )
            )
        )
    )
)
