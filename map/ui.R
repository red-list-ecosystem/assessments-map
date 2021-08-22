library(leaflet)
require(DT)
require(tidyr)

navbarPage("Ecosystem assessments", id="nav",

  tabPanel("Interactive map",
    div(class="outer",
      tags$head(
        # Include our custom CSS
        includeCSS("styles.css")
      ),
      # If not using custom CSS, set height of leafletOutput to a number instead of percent
      leafletOutput("map", width="100%", height="100%"),

      # Shiny versions prior to 0.11 should use class = "modal" instead.
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
        width = 430, height = "auto",

        tags$a(href='http://iucnrle.org', tags$img(src='logo.png', width = 300)),
        h2("Assessments by country"),
        DTOutput("totals"),
        hr(),
        div(
          'Data compiled from the ', tags$a(href='https://iucnrle.org/resources/published-assessments/',tags$em('IUCN Red List of Ecosystem webpage')), ' the ',tags$a(href='https://assessments.iucnrle.org',tags$em('IUCN Red List of Ecosystem database')),'and other sources by José R. Ferrer-Paris (UNSW), Lila García, Arlene Cardozo-Urdaneta and Irene Zager (Provita).'
        )
      ),



      tags$div(id="cite",
        'Polygon layer based on ', tags$a(href='http://thematicmapping.org/downloads/world_borders.php',tags$em('TM World Borders v0.3'))
      )
    )
  ),

  tabPanel("List of assessments",
    fluidRow(
      column(3,
             selectInput("country", "Countries and territories", c("All"="All", structure(slc.countries %>% pull(ISO2), names=slc.countries %>% pull(NAME))), multiple=FALSE),
             radioButtons("protocol", "Assessment protocols:",
                          c("IUCN RLE (v2)" = "RLE2",
                            "Other" = "other",
                            "All" = "all"))
      ),
      column(9,
        DTOutput("table")
      )
    ),

  conditionalPanel("false", icon("crosshair"))
  )
)
