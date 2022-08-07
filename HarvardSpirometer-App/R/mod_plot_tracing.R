### Module: Plot Tracing

#| External PKG
#| remotes::install_github("Lightbridge-KS/rslab")

library(shiny)
library(rslab)
library(fontawesome)

# Function: Plot Harvard Tracing ------------------------------------------

plot_Harvard_tracing <- function(f = "cos",
                                 t_start = 0,
                                 t_end = 1,
                                 paper_speed = 25,
                                 TV = 500,
                                 RR = 20,
                                 oxycons = 10, # Start at 10
                                 oxycons_unit = c("L/hr", "ml/min"),
                                 y_int_O2_line = 5, # Start at 5
                                 seq_x_by = 0.01, # Finer Control
                                 epsilon_sd = NULL,
                                 seed = 1,
                                 subtitle = TRUE
) {

  oxycons_unit <- match.arg(oxycons_unit)

  df_sim <- rslab::sim_Harvard_tracing(
    f = f, t_start = t_start, t_end = t_end, paper_speed = paper_speed,
    TV = TV, RR = RR, oxycons = oxycons, oxycons_unit = oxycons_unit,
    y_int_O2_line = y_int_O2_line, seq_x_by = seq_x_by,
    epsilon_sd = epsilon_sd, seed = seed
  )
  ## Add Subtitle
  subtitle <- if(!is.null(subtitle) && subtitle){
    latex2exp::TeX(
      glue::glue("(TV = <TV> ml, RR = <RR>/min, $\\dot{V}o_2$ = <oxycons> <oxycons_unit>)",
                 .open = "<", .close = ">")
    )
  } else {
    NULL
  }

  df_sim |>
    ggplot2::ggplot() +
    # Waves
    ggplot2::geom_path(ggplot2::aes(x, y)) +
    # Oxygen line
    ggplot2::geom_smooth(ggplot2::aes(x, y_O2_line), method = "lm",
                         formula = "y~x", linetype = "dashed", size = 1) +
    # Expand Axis
    ggplot2::scale_y_continuous(limits = c(0, 50), minor_breaks = seq(0, 50, 1)) +
    ggplot2::scale_x_continuous(minor_breaks = seq(0, t_end*25, 1)) +
    # Labels
    ggplot2::labs(title = "Simulation of Harvard Spirometer Tracing",
                  x = "x (mm)", y = "y (mm)") +
    ggplot2::labs(subtitle = subtitle) +
    ggplot2::theme_bw()

}



# Mod: plot_Harvard_tracing UI -----------------------------------------------------------------
plot_Harvard_tracing_UI <- function(id) {
  ns <- NS(id)
  tabPanel(tags$span(fa("chart-line"), "Simulate Tracing"),
           sidebarLayout(
             sidebarPanel(
               h3("Respiratory Parameters"),
               br(),
               # helpText("Slide to adjust parameters"),
               sliderInput(ns("TV"), "Tidal Volume (mL)", value = 500, min = 0, max = 1500),
               sliderInput(ns("RR"), "Respiratory Rate (/min)", value = 20, min = 0, max = 40),
               sliderInput(ns("oxycons"), "Oxygen Consumption (L/hr)",
                           value = 10, min = 0, max = 50),
               checkboxInput(ns("subtitle"), "Add subtitle ?", value = TRUE),
               download_plot_UI(ns("download_plot"))
             ),
             mainPanel(
               plotOutput(ns("plot_tracing")),
               br(),
               helpText("Note: Respiratory cycle waveform was simulated by using cosine function;
                        It is not an accurate representation of real physiological breathing processes.")

             )
           )


  )
}

# Mod: plot_Harvard_tracing Server -----------------------------------------------------------------
plot_Harvard_tracing_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {

      plot_tracing <- reactive({

        plot_Harvard_tracing(TV = input$TV, RR = input$RR, oxycons = input$oxycons,
                             subtitle = input$subtitle)

      })

      output$plot_tracing <- renderPlot({

        plot_tracing()

      }, res = 96)

      download_plot_Server("download_plot", plot_tracing, filename = "tracing-simulated.png")

    }
  )
}
