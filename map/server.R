library(shiny)
library(leaflet)
library(leaflet.providers)
library(dplyr)
library(sf)
require(DT)
require(tidyr)

options(dplyr.summarise.inform = FALSE)

function(input, output, session) {

  #########
  ## MAP section

  # continental labels
  ct_labels <- sprintf("<p><strong>%s</strong><br/> Protocol: %s <br/> Assessment target: %s <br/> Reference: %s <br/>(ID: %s)</p>",
                       asm.continental$name, asm.continental$assessment_protocol_code,
                       asm.continental$included_ecosystems,asm.continental$ref_code,
                       asm.continental$asm_id) %>%
  lapply(htmltools::HTML)
  # national labels
  nt_labels <- sprintf("<p><strong>%s</strong><br/> Protocol: %s <br/> Assessment target: %s </p>",
                       asm.national$NAME, asm.national$protocol,asm.national$included_ecosystems ) %>%
    lapply(htmltools::HTML)
  nt_pal <- colorFactor("YlOrBr", domain = asm.national$colorgrp)
  # national labels
  sn_labels <- sprintf("<p><strong>%s</strong><br/> Protocol: %s <br/> Assessment target: %s </p>",
                       asm.subnational$name, asm.subnational$assessment_protocol_code,asm.subnational$included_ecosystems ) %>%
    lapply(htmltools::HTML)
  # strategic labels and icons
  st_labels <- sprintf("<strong>%s</strong><br/>%s<br/>Category: <strong>%s</strong>",
                      asm.strategic$eco_name, asm.strategic$name, asm.strategic$overall_risk_category ) %>%
    lapply(htmltools::HTML)
  st_icons <- icons(
    iconUrl = sprintf("%s.png",tolower(asm.strategic$overall_risk_category)),
    iconWidth = 25, iconHeight = 25
  )
  st_cluster <- markerClusterOptions(iconCreateFunction=JS("function (cluster) {
  var childCount = cluster.getChildCount();
  if (childCount < 5) {
    c = 'rgba(181, 126, 140, 0.6);'
  } else if (childCount < 10) {
    c = 'rgba(140, 184, 112, 0.6);'
  } else {
    c = 'rgba(141, 128, 183, 0.6);'
  }
  return new L.DivIcon({ html: '<div style=\"background-color:'+c+'\"><span>' + childCount + '</span></div>', className: 'marker-cluster', iconSize: new L.Point(40, 40) });

  }"))


  # Leaflet map
  output$map <- renderLeaflet({
      leaflet() %>%
          addProviderTiles(providers$CartoDB.Positron) %>%
          setView(lng = 40, lat = 10, zoom = 2) %>%
      addLayersControl(
        overlayGroups = c("Systematic assessments - continental", "Systematic assessments - national", "Systematic assessments - subnational","Strategic assessments"),
        options = layersControlOptions(collapsed = FALSE),
        position = "bottomleft"
      )  %>%
      addPolygons(data = asm.national, layerId= ~NAME,
                  fillColor = ~nt_pal(colorgrp),
                  highlightOptions = highlightOptions(weight = 2, color = 'black'),
                  color = 'black', weight = 0.4, fillOpacity = 0.45, label=nt_labels,
                  group="Systematic assessments - national") %>%
      addPolygons(data = asm.continental, layerId= ~asm_id,
                  fillColor = 'grey',
                  highlightOptions = highlightOptions(weight = 2, color = 'black'),
                  color = 'blue', weight = 0.4, fillOpacity = 0.45, label=ct_labels,
                  group="Systematic assessments - continental") %>%
      addMarkers(data = asm.strategic, layerId= ~eco_id,icon = st_icons,
                 label=st_labels,
                 # clusterOptions = st_cluster, # not convinced
                 group="Strategic assessments") %>%
      addMarkers(data = asm.subnational, layerId= ~asm_id,
                 label=sn_labels,
                 group="Systematic assessments - subnational") %>%
      hideGroup("Systematic assessments - continental") %>%
      # hideGroup("Strategic assessments") %>%
      hideGroup("Systematic assessments - subnational")
  })

#########
## TABLE section
# output detailed table
  output$table <- renderDT({
    dts <- asm.list %>%
      filter(
        is.null(input$country) | input$country %in% "All" | iso2 %in% input$country,
        switch(input$protocol,all={TRUE},
               RLE2={assessment_protocol_code %in% rle.asms},
               other={!(assessment_protocol_code %in% rle.asms)}),
        switch(input$target,all={TRUE},
               efg={included_ecosystems %in% "single functional group"},
               single={included_ecosystems %in% "single biome"},
               related={included_ecosystems %in% "few related biomes"},
               multiple={included_ecosystems %in% "multiple biomes"}),
        switch(input$asmtype,all={TRUE},
               systematic={!(asm_type %in% "Strategic")},
               continental={asm_type %in% "Systematic (Continental)"},
               national={asm_type %in% "Systematic"},
               subnational={asm_type %in% "Systematic (Subnational)"},
               strategic={asm_type %in% "Strategic"})
      ) %>% distinct(name,.keep_all = TRUE) %>%
      transmute(Assessment=name,Reference=ref_code,Protocol=assessment_protocol_code)
    DT::datatable(dts)
      })


  observeEvent(input$table_cell_clicked, {
    info = input$table_cell_clicked
    # do nothing if not clicked yet, or the clicked cell is not in the 1st column
    if (is.null(info$value) || info$col != 2) return()
    updateTextInput(session, 'x2', value = info$value)
  })

  # highlight the point of the selected cell
  output$ref = renderText({
    id = input$x2
    if (id != '') {
      refs %>% filter(ref_code %in% id) %>% pull(reference)
    }
  })
}
