
library(shiny)
library(markdown)

library(fontawesome)
#fa("github")

# Main UI -----------------------------------------------------------------


shinyUI(
  navbarPage(title = "Harvard Spirometer",
             theme = bslib::bs_theme(bootswatch = "cosmo",
                                     "enable-gradients" = TRUE, "enable-shadows" = TRUE,
                                     primary = "#2080E9", secondary = "#BA3857",
                                     font_scale = NULL
             ),
             plot_Harvard_tracing_UI("simulate"),
             tabPanel("About", includeMarkdown("about.md"))
             )
)
