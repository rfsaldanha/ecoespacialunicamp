#### Pasta de trabalho

#### Pacote
library(httr)
token <- "382e58a21d664dc91e86a6c5262e39f5"
library(tidyverse)
library(leaflet)
library(htmltools)

# Função para consulta da API
cepaberto <- function(cep, token){
  require(httr)
  url <- "http://www.cepaberto.com/api/v3/cep?cep="
  
  requisicao <- GET(paste0(url,cep),
                    add_headers(Authorization = paste0('Token token="' , token , '"')))
  res <- content(requisicao, as = "parsed")
  
  tentativas <- 0
  while(length(res) <= 2){
    requisicao <- GET(paste0(url,cep),
                      add_headers(Authorization = paste0('Token token="' , token , '"')))
    res <- content(requisicao, as = "parsed")
    Sys.sleep(5)
    tentativas <- tentativas + 1
    if(tentativas == 10){
      break
    }
  }
  
  df <- data.frame( 
             lat = ifelse(is.null(res$latitude), NA, as.numeric(res$latitude)), 
             lng = ifelse(is.null(res$longitude), NA, as.numeric(res$longitude)), 
             alt = ifelse(is.null(res$altitude), NA, as.numeric(res$altitude)),
             logradouro = ifelse(is.null(res$logradouro), NA, as.character(res$logradouro)), 
             bairro = ifelse(is.null(res$bairro), NA, as.character(res$bairro)), 
             cod_ibge = ifelse(is.null(res$cidade$ibge), NA, as.numeric(res$cidade$ibge)),
             mun = ifelse(is.null(res$cidade$nome), NA, as.character(res$cidade$nome)), 
             uf = ifelse(is.null(res$estado$sigla), NA, as.character(res$estado$sigla)), 
             ddd = ifelse(is.null(res$cidade$ddd), NA, as.integer(res$cidade$ddd))
  )
  
  return(df)
} 

# Geocodificar um único endereço
cepaberto(20520130, token)



#### Trabalhando com a RAIS - Estabelecimento

## Carregar dados de Juiz de Fora
load("estab.RData")

## Geocodifica estabelecimentos

# Cria colunas para lat e lng
estab$lat <- NA
estab$lng <- NA

# Arquivo de CEPs
ref_cep <- data.frame(cep = as.integer(), lat = as.numeric(), lng = as.numeric())
#load("ref_cep.RData")

for(i in 1:nrow(estab)){
  # Isola CEP a ser consultado
  cep <- estab$`CEP Estab`[i]
  
  # Confere se o CEP é NA
  if(is.na(cep)){ next }
  
  # Confere se o CEP está na lista de referência
  if(cep %in% ref_cep$cep){
    # Se estiver, usa o lat e lng da lista
    sub <- ref_cep[ref_cep$cep == cep,]
    estab$lat[i] <- sub$lat
    estab$lng[i] <- sub$lng
  } else {
    # Se não estiver, consulta a API
    Sys.sleep(1)
    res <- cepaberto(cep, token)
    estab$lat[i] <- res$lat
    estab$lng[i] <- res$lng
    
    # e guarda o novo CEP na lista
    tmp <- data.frame(cep = cep, lat = res$lat, lng = res$lng)
    ref_cep <- rbind(ref_cep, tmp)
  }
  
  print(paste("Linha", i, "de", nrow(estab)))
}

# Salva CEPs de referência
save(ref_cep, file = "ref_cep.RData")

# Ver no mapa
leaflet(estab) %>%
  addTiles() %>%
  addMarkers(lng = ~lng, lat = ~lat, label = ~htmlEscape(as.character(estab$`CEP Estab`)))




