library(shiny)
library(leaflet)
library(leaflet.providers)
library(dplyr)
library(sf)
require(DT)
require(tidyr)

options(dplyr.summarise.inform = FALSE)

function(input, output) {

    # create a reactive value that will store the click position
    data_of_click <- reactiveValues(clickedMarker=NULL)
    #labels
    my_labels = sprintf("<strong>%s</strong><br/>%s<br/>Category: <strong>%s</strong>",
                        asm.points$eco_name, asm.points$name, asm.points$overall_risk_category ) %>%
        lapply(htmltools::HTML)
    ct_labels <- sprintf("<strong>%s</strong>",
                         slc.countries$NAME) %>%
        lapply(htmltools::HTML)

    bins <- c(1, 2, 5, 10, Inf)
    #palN <- colorBin("RdPu", domain = slc.countries$n_assessments, bins = bins)
    palF <- colorFactor("YlOrBr", domain = slc.countries$n_asm)

    catIcons <- icons(
        iconUrl = sprintf("%s.png",tolower(asm.points$overall_risk_category)),
        iconWidth = 25, iconHeight = 25
    )

    # Leaflet map
    output$map <- renderLeaflet({
        leaflet() %>%
            # Esri.OceanBasemap, CartoDB.Voyager Stamen.Toner  Stamen.TonerLite Esri.WorldStreetMap  Esri.WorldGrayCanvas
            addProviderTiles(providers$CartoDB.Positron) %>%
            setView(lng = 20, lat = 0, zoom = 2) %>%
            addPolygons(data = slc.countries, layerId= ~ISO2, fillColor = ~palF(n_asm),
                        highlightOptions = highlightOptions(weight = 2, color = 'black'),
                        color = 'blue', weight = 0.4, fillOpacity = 0.45,label=ct_labels,group="Assessments per country") %>%
            #addCircleMarkers(data = asm.points, layerId= ~eco_id,color = ~pal(ocat), label=my_labels)
            # Layers control
            addLayersControl(
                overlayGroups = c("Assessments per country", "Strategic assessments"),
                options = layersControlOptions(collapsed = FALSE),
                position = "topleft"
            ) %>%
            addLegend(pal = palF, values = slc.countries$n_asm,opacity = 0.45, title = "Valid IUCN RLE assmnts.",
                      na.label = "(other protocols)",
                      position = "topleft", group="Assessments per country") %>%
            addMarkers(data = asm.points, layerId= ~eco_id,icon = catIcons, label=my_labels,group="Strategic assessments") %>%
            hideGroup("Strategic assessments")
    })

    # store the click
    observeEvent(input$map_shape_click,{
        data_of_click$clickedMarker <- input$map_shape_click
        data_of_click$Country <- slc.countries %>% filter(ISO2 %in% input$map_shape_click$id) %>% pull(NAME)
    })

    # output summary table
    output$totals <- renderDT({
        my_place=data_of_click$clickedMarker$id

        if(is.null(my_place)) {

        } else {
            dts <- asm.countries %>% filter(iso2==my_place) %>% mutate(Protocol=if_else(grepl("IUCN RLE v2",assessment_protocol_code),"IUCN RLE (v2)","Other"),Type=asm_type) %>% group_by(Type,Protocol) %>% summarise(total=n()) %>% pivot_wider(id_cols=Type,names_from=Protocol,values_from=total)
            #dts <- asm.countries %>% filter(iso2==my_place) %>% transmute(Protocol=assessment_protocol_code,Type=asm_type) %>% table
        }
    },caption=sprintf('List of ecosystem assessments in %s',data_of_click$Country), options = list(lengthChange = FALSE,pageLength=-1,paging=FALSE,info=FALSE,searching=FALSE),server=FALSE)

    # output detailed table

    output$table <- renderDT({
         dts <- asm.countries %>% filter(
             is.null(input$country) | input$country %in% "All" | iso2 %in% input$country,
                     switch(input$protocol,all={TRUE},
                        RLE2={assessment_protocol_code %in% rle.asms},
                        other={!(assessment_protocol_code %in% rle.asms)})
                    ) %>% distinct(name,.keep_all = TRUE) %>%
                transmute(Assessment=name,Reference=ref_code,Protocol=assessment_protocol_code)
            DT::datatable(dts)
        })
}
