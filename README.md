# Text Mining - Pedidos de Acesso à Informação à Prefeitura de São Paulo em 2018

http://dados.prefeitura.sp.gov.br/pt_PT/dataset/pedidos-de-informacao-protocolados-a-prefeitura-via-e-sic1

## Introdução

Em 18 de novembro de 2011, foi sancionada a Lei nº 12.527 que regulamenta o direito constitucional de acesso à informações públicas aos cidadãos, com o objetivo de fortalecer a democracia brasileira e as políticas de transparência pública. A chamada Lei de Acesso à Informação (LAI), em linhas gerais diz que, com exceção de informações pessoais e sigilosas legalmente estabelecidas, toda informação produzida pelo estado é pública.

Os principais aspectos da LAI são:

> -	Acesso é a regra, o sigilo, a exceção (divulgação máxima)
> -	Requerente não precisa dizer por que e para que deseja a informação (não exigência de motivação)
> -	Hipóteses de sigilo são limitadas e legalmente estabelecidas (limitação de exceções)
> -	Fornecimento gratuito de informação, salvo custo de reprodução (gratuidade da informação)
> -	Divulgação proativa de informações de interesse coletivo  e geral (transparência ativa)
> -	Criação de procedimentos e prazos que facilitam o acesso à informação (transparência passiva)
>
> <sup>*Fonte: http://www.acessoainformacao.gov.br/assuntos/conheca-seu-direito/principais-aspectos*</sup>

Para garantir a transparência passiva, foi criado o Sistema Eletrônico do Serviço de Informações ao Cidadão (e-SIC), que permite qualquer pessoa, física ou jurídica, fazer pedidos de acesso à informação e acompanhar o tramite.

## Objetivo

Este trabalho tem como objetivo realizar uma mineração de texto nos pedidos de acesso à informação realizados à prefeitura de São Paulo no ano de 2018 com o intuito de identificar as principais necessidades de informações da população no que diz respeito à educação, saúde e transportes visando fornecer insumo ao planejamento de melhora dos serviços públicos para os anos subsequentes e melhora da comunicação com o público.

## Tratamento da Base e Análise Exploratória

A base que estamos analisando possui 35.689 registros com 8 colunas. Essa base foi obtida no portal de dados abertos da prefeitura de São Paulo no link abaixo:

*http://dados.prefeitura.sp.gov.br/pt_PT/dataset/pedidos-de-informacao-protocolados-a-prefeitura-via-e-sic1*

As colunas estão descritas na tabela abaixo:

Coluna             |  Definição
:-------------------------:|:-------------------------:
cd_atendimento_pedido | Código único para cada movimentação do pedido (a partir de 2018)
status_nome | Nome do status do pedido (Ex: Atendido, finalizado, 2ª instância, etc.)
cd_orgao | Código de identificação do órgão responsável pelo pedido
orgao_nome | Nome do órgão responsável pelo pedido
cd_pedido | Código do pedido (protocolo único de cada pedido)
dc_pedido | Conteúdo do Pedido
dt_resposta_atendimento | Data do pedido ou movimentação
dc_resposta | Resposta do pedido

