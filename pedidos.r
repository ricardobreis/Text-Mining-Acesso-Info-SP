library(plotly)
library(dplyr)
library(lubridate)
library(stringr)

pedidos2018 <- read.csv("~/Desktop/Analises/pedidorespondido2018atualizado.csv", sep=";", comment.char="#", stringsAsFactors = FALSE , encoding = "utf-8")
glimpse(pedidos2018)

################################################################### TIDYING #########################################################################

pedidos2018$orgao_nome    <- iconv(pedidos2018$orgao_nome, "latin1", "UTF-8")
pedidos2018$status_nome   <- iconv(pedidos2018$status_nome, "latin1", "UTF-8")
pedidos2018$dc_pedido     <- iconv(pedidos2018$dc_pedido, "latin1", "UTF-8")
pedidos2018$dc_resposta   <- iconv(pedidos2018$dc_resposta, "latin1", "UTF-8")

pedidos2018$dt_resposta_atendimento <- str_replace_all(pedidos2018$dt_resposta_atendimento, "/", "-")
pedidos2018$dt_resposta_atendimento = dmy_hm(pedidos2018$dt_resposta_atendimento)

pedidos2018$orgao_sigla = str_split(pedidos2018$orgao_nome, '-', simplify=TRUE)[,1]
pedidos2018_unicos <- pedidos2018[unique(pedidos2018$cd_pedido),]

pedidos_x_orgao <- plot_ly(
  x = names(tail(sort(table(pedido_unicos$orgao_sigla)),10)),
  y = tail(sort(table(pedido_unicos$orgao_sigla)),10),
  name = "Pedidos",
  type = "bar"
  ) %>%
  layout(title = 'Pedidos por Orgao')

