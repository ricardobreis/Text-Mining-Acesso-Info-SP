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

library(dplyr)
library(lubridate)
library(stringr)
library(tm)
library(tidytext)
library(forcats)
library(ggplot2)


# Leitura de Dados --------------------------------------------------------

pedidos2018 <- read.csv("C:/Users/Ricardo/Documents/R-Projetos/AcessoInfoSP/pedidorespondido2018atualizado.csv", sep=";", comment.char="#", stringsAsFactors = TRUE , encoding = "utf-8")

glimpse(pedidos2018)
head(pedidos2018)
summary(pedidos2018)

# Tidying  ----------------------------------------------------------------

pedidos2018$orgao_nome    <- iconv(pedidos2018$orgao_nome, "latin1", "UTF-8")
pedidos2018$status_nome   <- iconv(pedidos2018$status_nome, "latin1", "UTF-8")
pedidos2018$dc_pedido     <- iconv(pedidos2018$dc_pedido, "latin1", "UTF-8")
pedidos2018$dc_resposta   <- iconv(pedidos2018$dc_resposta, "latin1", "UTF-8")

pedidos2018$dt_resposta_atendimento <- str_replace_all(pedidos2018$dt_resposta_atendimento, "/", "-")
pedidos2018$dt_resposta_atendimento <- dmy_hm(pedidos2018$dt_resposta_atendimento)
pedidos2018$data <- paste0(year(pedidos2018$dt_resposta_atendimento), "-", ifelse(nchar(month(pedidos2018$dt_resposta_atendimento)) < 2, paste0("0",month(pedidos2018$dt_resposta_atendimento)),month(pedidos2018$dt_resposta_atendimento)) , "-", ifelse(nchar(day(pedidos2018$dt_resposta_atendimento)) < 2, paste0("0",day(pedidos2018$dt_resposta_atendimento)),day(pedidos2018$dt_resposta_atendimento)))
pedidos2018$ano <- year(pedidos2018$dt_resposta_atendimento)
pedidos2018$mes <- month(pedidos2018$dt_resposta_atendimento)
pedidos2018$dia <- day(pedidos2018$dt_resposta_atendimento)

pedidos2018$orgao_sigla = str_split(pedidos2018$orgao_nome, '-', simplify=TRUE)[,1]


# Análise Exploratória ----------------------------------------------------

# Contagem de pedidos únicos por órgão iniciados e finalizados
contagem_pedidos_orgao <- pedidos2018 %>%
  subset(status_nome == "Em tramitação" | status_nome == "Finalizado") %>%
  count(orgao_sigla, status_nome) %>%
  group_by(status_nome) %>%
  arrange(desc(n)) %>%
  top_n(10, n) %>%
  mutate(orgao_sigla2 = fct_reorder(orgao_sigla, n))

# Plot de pedidos únicos por órgão iniciados e finalizados
ggplot(contagem_pedidos_orgao, aes(x = orgao_sigla2, y = n, fill = status_nome)) +
  geom_col() +
  facet_wrap(~ status_nome, scales = "free_y") +
  coord_flip() +
  labs(
    title = "Pedidos por Órgão",
    subtitle = "TOP 10 - Pedidos por Órgão",
    x = "Órgãos",
    y = "Pedidos"
  )

# Contagem pedidos por mês em 2018
contagem_pedidos_mes <- pedidos2018 %>%
  subset(status_nome == "Em tramitação" & ano == 2018) %>%
  group_by(mes) %>%
  count() 

# Plot de pedidos por mês em 2018
ggplot(contagem_pedidos_mes, aes(x = mes, y = n, group = 1)) +
  geom_line() +
  labs(
    title = "Pedidos por Dia",
    subtitle = "Pedidos por Dia em Janeiro de 2018",
    x = "Dias",
    y = "Pedidos"
  )

# Contagem pedidos por dia em Maio de 2018
contagem_pedidos_dia <- pedidos2018 %>%
  subset(status_nome == "Em tramitação" & mes == 5 & ano == 2018) %>%
  group_by(data) %>%
  count(data)

# Plot de pedidos por dia em Maio de 2018
ggplot(contagem_pedidos_dia, aes(x = data, y = n, group = 1)) +
  geom_line() +
  labs(
    title = "Pedidos por Dia",
    subtitle = "Pedidos por Dia em Maio de 2018",
    x = "Dias",
    y = "Pedidos"
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
  rbind(custom_stop_words_portuguese)

# Tokenizar e remover stop words
tidy_pedidos <- pedidos2018 %>%
  unnest_tokens(word, dc_pedido) %>%
  anti_join(as.data.frame(stop_words_portuguese2), by = c("word" = "word"))

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

