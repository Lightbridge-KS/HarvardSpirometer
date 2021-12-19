
library(shiny)
library(markdown)


# Main Server -------------------------------------------------------------


shinyServer(function(input, output) {

  # bslib::bs_themer(gfonts = TRUE, gfonts_update = FALSE)
  plot_Harvard_tracing_Server("simulate")

})
