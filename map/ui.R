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
        h2("Systematic assessments"),
        p("Simultaneous assessment of several ecosystems in a large region using similar indicators and methods."),
        h3("Continental"),
        p("The continental assessments of marine, freshwater and terrestrial habitats in Europe follows a modified version of the IUCN RLE protocol.",
        br(),"The continental assessments in the Americas follows the IUCN RLE protocol but is restricted to forest vegetation (Few related biomes)."),
        h3("National"),
        p("Three national assessments include marine and terrestrial ecosystems/habitats. The rest are restricted to terrestrial ecosystems.",
        br(),"Two national assessments are restricted to forest ecosystems.",br(),"Six national assessments do not follow the IUCN RLE protocol."),
        h3("Subnational"),
        p("Four assessments are restricted to regions within one country.",
          br(),"One assessments focuses on a single region (Congo Basin) extending to multiple countries."),
        h2("Strategic assessments"),
        p("Detailed assessment focused on a single region and one or few related ecosystems.",br(),"Might extent to two or more countries."),

        hr(),
        div(
          'Data compiled from the ',
          tags$a(href='https://assessments.iucnrle.org',
                 tags$em('IUCN Red List of Ecosystem database')),
          ', the ',
          tags$a(href='http://iucnrle.org',
                 tags$em('IUCN Red List of Ecosystem webpage')),
          ', the ',
          tags$a(href='http://doi.org/10.1111/conl.12666',
                 tags$em('Bland et al. (2019)')),
          'and other sources by José R. Ferrer-Paris (UNSW), Lila García, Arlene Cardozo-Urdaneta and Irene Zager (Provita).'
        ),
        tags$div(id="cite",
          'Polygons based on ',
          tags$a(href='http://thematicmapping.org/downloads/world_borders.php',tags$em('TM World Borders v0.3')),
          ", ",
          tags$a(href='https://www.marineregions.org/',tags$em('Marine boundaries and Exclusive Economical Zones')),
          " and the",
          tags$a(href='https://forum.eionet.europa.eu/european-red-list-habitats/',tags$em('European Red List of Habitats')),
        )
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
