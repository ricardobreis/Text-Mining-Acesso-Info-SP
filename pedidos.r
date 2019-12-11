library(plotly)
library(dplyr)
library(lubridate)
library(stringr)
library(tm)
library(tidytext)
library(forcats)

pedidos2018 <- read.csv("~/Desktop/Analises/pedidos-sp/pedidorespondido2018atualizado.csv", sep=";", comment.char="#", stringsAsFactors = FALSE , encoding = "utf-8")
glimpse(pedidos2018)

################################################################### TIDYING #########################################################################

pedidos2018$orgao_nome    <- iconv(pedidos2018$orgao_nome, "latin1", "UTF-8")
pedidos2018$status_nome   <- iconv(pedidos2018$status_nome, "latin1", "UTF-8")
pedidos2018$dc_pedido     <- iconv(pedidos2018$dc_pedido, "latin1", "UTF-8")
pedidos2018$dc_resposta   <- iconv(pedidos2018$dc_resposta, "latin1", "UTF-8")

pedidos2018$dt_resposta_atendimento <- str_replace_all(pedidos2018$dt_resposta_atendimento, "/", "-")
pedidos2018$dt_resposta_atendimento = dmy_hm(pedidos2018$dt_resposta_atendimento)

pedidos2018$orgao_sigla = str_split(pedidos2018$orgao_nome, '-', simplify=TRUE)[,1]

########################## Pedidos Por Orgão
pedidos2018_unicos <- pedidos2018[unique(pedidos2018$cd_pedido),]

pedidos_x_orgao <- plot_ly(
  x = names(tail(sort(table(pedidos2018_unicos$orgao_sigla)),10)),
  y = tail(sort(table(pedidos2018_unicos$orgao_sigla)),10),
  name = "Pedidos",
  type = "bar"
  ) %>%
  layout(title = 'Pedidos por Orgao')

########################## Pedidos 
tramitacao <- filter(pedidos2018, pedidos2018$status_nome == "Em tramitação")
tramitacao <- table(tramitacao$orgao_nome)

finalizado <- filter(pedidos2018, pedidos2018$status_nome == "Finalizado")
finalizado <- table(finalizado$orgao_nome)
orgaos <- names(finalizado)

data <- data.frame(orgaos, tramitacao, finalizado)

p <- plot_ly(data, x = ~orgaos, y = ~tramitacao, type = 'bar', name = 'tramitacao') %>%
  add_trace(y = ~finalizado, name = 'finalizado') %>%
  layout(yaxis = list(title = 'Count'), barmode = 'group')

########################## Text Mining 
stop_words_portuguese <- NULL
stop_words_portuguese$word <- stopwords("portuguese")

tidy_pedidos <- pedidos2018 %>%
  unnest_tokens(word, dc_pedido) %>%
  anti_join(as.data.frame(stop_words_portuguese), by = c("word" = "word"))

contagem <- tidy_pedidos %>%
  count(word) %>%
  arrange(desc(n)) %>%
  top_n(50, n) %>%
  mutate(word2 = fct_reorder(word, n))
