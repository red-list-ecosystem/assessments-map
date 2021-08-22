# Map of IUCN Red List of Ecosystem assessments

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5234108.svg)](https://doi.org/10.5281/zenodo.5234108)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)


Data compiled from the [IUCN Red List of Ecosystem webpage](https://iucnrle.org/resources/published-assessments/) the [IUCN Red List of Ecosystem database](https://assessments.iucnrle.org) and other sources by José R. Ferrer-Paris (UNSW), Lila García, Arlene Cardozo-Urdaneta and Irene Zager (Provita). Code written by José R. Ferrer-Paris (UNSW).

Web application written and deployed with [RStudio](https://www.rstudio.com), [Shiny Apps](https://shiny.rstudio.com/) and [Leaflet](https://leafletjs.com/). Polygon layer is based on the [TM World Borders v0.3](http://thematicmapping.org/downloads/world_borders.php), with small modifications.

## Interactive map
The map shows the nr. of valid IUCN RLE assessments per country or territory and the location of some strategic assessments. We considered "valid" assessments those that use the IUCN Red List of Ecosystems protocol version 2.0 or higher and evaluated at least two different criteria. Valid assessments can be:

- **Strategic**: detailed assessment focused on a single region and one or few related ecosystems, see examples here: https://assessments.iucnrle.org/search
- **Systematic**: simultaneous assessment of several ecosystems in a large region using similar indicators and methods. Mostly national assessments, but some are regional or even continental. See examples here: https://assessments.iucnrle.org/searchsys

All other assessment are summarised as "others". This includes assessment that follow the IUCN RLE v2 protocol but evaluated only one or more subcriteria from a single criterion, these are labelled as "partial" assessments. We also include some ecosystem assessment that use alternative or outdated protocols.

Clicking on the map will show the total number of assessment in the country discriminated by protocol and type.

## List of assessments

This Table includes a list of assessments per country, with reference and assessment protocol.
