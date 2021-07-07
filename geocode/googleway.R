#### Pacote
library(googleway)

# Geocodificar um único endereço
token = "sua_chave"
res <- google_geocode(address = "Rua Camaragibe 9 tijuca rio de janeiro brasil", key = token)
res$results$geometry$location$lat
res$results$geometry$location$lng
