#### Pacote
#devtools::install_github("dkahle/ggmap")
library(ggmap)
register_google(key = "AIzaSyB28h_cqf9flJDWybxLaPAg4V1NjDGqtcY")

# Geocodificar um único endereço
res <- geocode("Rua Camaragibe 9 - Tijuca - Rio de Janeiro - Brasil - CEP 20520130")
res$lon
res$lat

# Geocodificar vários endereços
df <- data.frame(ender = c("Rua Camaragibe 9, Rio de Janeiro", 
                           "Rua São Mateus 122, Juiz de Fora",
                           "Avenida Paulista, 1112, São Paulo"))
df$ender <- as.character(df$ender)

df2 <- mutate_geocode(df, ender)
