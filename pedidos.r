################################################################################################
#
# ANÁLISE DE MÍDIAS SOCIAIS E MINERAÇÃO DE TEXTO - MBA Business Analytics e Big Data
# Por: RICARDO REIS
#
# CASE - PEDIDOS DE ACESSO À INFORMAÇÃO: PREFEITURA DE SP
#
#
################################################################################################


# Carrega Pacotes ---------------------------------------------------------

library(plotly)
library(dplyr)
library(lubridate)
library(stringr)
library(tm)
library(tidytext)
library(forcats)
library(ggplot2)


# Leitura de Dados --------------------------------------------------------

pedidos2018 <- read.csv("~/Desktop/Analises/pedidos-sp/pedidorespondido2018atualizado.csv", sep=";", comment.char="#", stringsAsFactors = TRUE , encoding = "utf-8")

glimpse(pedidos2018)
head(pedidos2018)
summary(pedidos2018)

# Tidying  ----------------------------------------------------------------

pedidos2018$orgao_nome    <- iconv(pedidos2018$orgao_nome, "latin1", "UTF-8")
pedidos2018$status_nome   <- iconv(pedidos2018$status_nome, "latin1", "UTF-8")
pedidos2018$dc_pedido     <- iconv(pedidos2018$dc_pedido, "latin1", "UTF-8")
pedidos2018$dc_resposta   <- iconv(pedidos2018$dc_resposta, "latin1", "UTF-8")

pedidos2018$dt_resposta_atendimento <- str_replace_all(pedidos2018$dt_resposta_atendimento, "/", "-")
pedidos2018$dt_resposta_atendimento = dmy_hm(pedidos2018$dt_resposta_atendimento)

pedidos2018$orgao_sigla = str_split(pedidos2018$orgao_nome, '-', simplify=TRUE)[,1]


# Análise Exploratória ----------------------------------------------------

# Contagem de pedidos únicos por órgão
contagem_orgao <- pedidos2018 %>%
  subset(status_nome == "Em tramitação") %>%
  count(orgao_sigla) %>%
  arrange(desc(n)) %>%
  top_n(10, n) %>%
  mutate(orgao_sigla2 = fct_reorder(orgao_sigla, n))

# Plot de pedidos únicos por órgão
ggplot(contagem_orgao, aes(x = orgao_sigla2, y = n)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Contagem de Palavras",
    subtitle = "Contagem de Palavras Geral",
    x = "Palavras",
    y = "Contagem"
  )


# Text Mining -------------------------------------------------------------

stop_words_portuguese <- NULL
stop_words_portuguese$word <- stopwords("portuguese")

# Adicionando stop words
custom_stop_words_portuguese <- tribble(
  ~word,
  "xxxxx", 
  "é", 
  "2017", 
  "2", 
  "2018", 
  "xxxxx", 
  "solicito", 
  "prefeitura", 
  "gostaria", 
  "informações"
)

stop_words_portuguese2 <- stop_words_portuguese %>% 
  rbind(custom_stop_words)

# Tokenizar e remover stop words
tidy_pedidos <- pedidos2018 %>%
  unnest_tokens(word, dc_pedido) %>%
  anti_join(as.data.frame(stop_words2), by = c("word" = "word"))

# Contar palavras
contagem <- tidy_pedidos %>%
  count(word) %>%
  arrange(desc(n)) %>%
  top_n(50, n) %>%
  mutate(word2 = fct_reorder(word, n))

# Plotar contagem de palavras
ggplot(contagem, aes(x = word2, n)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Contagem de Palavras",
    subtitle = "Contagem de Palavras Geral",
    x = "Palavras",
    y = "Contagem"
  )

# Contar palavras por órgão
contagem_orgao <- tidy_pedidos %>%
  filter(cd_orgao %in% c(67, 16, 10)) %>%
  count(word, orgao_sigla) %>%
  group_by(orgao_sigla) %>%
  arrange(desc(n)) %>%
  top_n(10, n) %>%
  ungroup() %>% 
  mutate(word2 = fct_reorder(word, n))


# Plotar contagem de palavras
ggplot(contagem_orgao, aes(x = word2, n, fill = orgao_sigla)) +
  geom_col() +
  facet_wrap(~ orgao_sigla, scales = "free_y") +
  coord_flip() +
  labs(
    title = "Contagem de Palavras",
    subtitle = "Contagem de Palavras Geral",
    x = "Palavras",
    y = "Contagem"
  )
