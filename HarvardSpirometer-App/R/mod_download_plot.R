### Download Plot Module


# UI ----------------------------------------------------------------------


download_plot_UI <- function(id, label = "Download Plot", ...) {
  ns <- NS(id)
  tagList(
    downloadButton(ns("download_plot"), label = label, ... )
  )
}


# Server ------------------------------------------------------------------



#' Download Plot Server
#'
#' @param id A shiny ID
#' @param plot_obj A plot object
#' @param filename filename of the plot
#' @param device Device to use
#'
#' @return Nothing
download_plot_Server <- function(id,
                                 plot_obj,
                                 filename = "plot.png",
                                 device = "png"
                                 ) {
  moduleServer(
    id,
    function(input, output, session) {

      output$download_plot <- downloadHandler(

        filename = filename,
        content = function(file){

          ggplot2::ggsave(plot = plot_obj(), filename = file,
                          width = 25.6, height = 16, units = "cm", dpi = "retina", scale = 1,
                          device = device)

        }
      )

    }
  )
}
