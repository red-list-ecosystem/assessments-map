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

      ),



      tags$div(id="cite",
        'Polygon layer based on ', tags$a(href='http://thematicmapping.org/downloads/world_borders.php',tags$em('TM World Borders v0.3'))
      )
    )
  ),

  tabPanel("List of assessments",
    fluidRow(
      column(3,
           selectInput("country", "Countries and territories",
                       c("All"="All",
                         structure(slc.countries$iso2,
                                   names=slc.countries$country_name)), multiple=FALSE),
           radioButtons("protocol", "Assessment protocols:",
                        c("IUCN RLE (v2)" = "RLE2",
                          "Other" = "other",
                          "All" = "all")),
           radioButtons("target", "Assessment target:",
                        c("Single ecosystem" = "efg",
                          "Multiple (same biome)" = "single",
                          "Multiple (related biomes)" = "related",
                          "Multiple (multiple biomes)" = "multiple",
                          "All" = "all"),selected = "all"),
           radioButtons("asmtype", "Assessment type:",
                        c("All systematic" = "systematic",
                          "Systematic - Continental" = "continental",
                          "Systematic - National" = "national",
                          "Systematic - Subnational" = "subnational",
                          "Strategic" = "strategic",
                          "All" = "all"
                          ),selected = "all")
    ),
    column(9,
      DTOutput("table")
    )
  ),
  fluidRow(hr(),h3("References"),
    column(6,p("Click on a citation in the table above to show the reference information."),textInput('x2', 'Showing reference info for'),
         textOutput("ref"))),

  conditionalPanel("false", icon("crosshair"))
  )
)
