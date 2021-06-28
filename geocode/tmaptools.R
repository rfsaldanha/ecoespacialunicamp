#### Pacote
library(tmaptools)

# Geocodificar um único endereço
res <- geocode_OSM("Rua Camaragibe 9 tijuca rio de janeiro brasil")
res$coords
