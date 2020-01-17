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

Após a leitura da base, tratamos a coluna dc_pedido, transformando-as para caracteres, em seguida dt_resposta_atendimento é reformatada, trocando-se “/” por “-“ para que se possa separa-la em 4 colunas: data, ano, mês e dia. Em seguida, a partir da coluna orgao_nome,  cria-se uma nova coluna apenas com a sigla do órgão para facilitar as visualizações.

A partir deste ponto inicia-se a análise exploratória com uma contagem de pedidos únicos por órgão com status de início (Em Tramitação) e fim (Finalizado). Pode-se observar na figura 1 abaixo os órgãos que mais recebem pedidos de acesso à informação, sendo áreas como educação, saúde e transportes as principais. Por conta disso e pelo fato de existirem mais de 100 órgãos no dataframe, optou-se por analisar os órgãos SME, SMS e SPTrans.

![](https://github.com/ricardobreis/Text-Mining-Acesso-Info-SP/blob/master/img/An%C3%A1lise%20Explorat%C3%B3ria%20-%20TOP%2010%20-%20Pedidos%20por%20%C3%93rg%C3%A3o%20Iniciados%20e%20Finalizados.png)

Seguindo a análise, pode-se observar na figura 2 o comportamento dos pedidos durante o ano de 2018, alcançando um pico de pedidos no mês de Maio e um declínio a partir de Setembro até Dezembro.

![](https://github.com/ricardobreis/Text-Mining-Acesso-Info-SP/blob/master/img/An%C3%A1lise%20Explorat%C3%B3ria%20-%20Pedidos%20por%20M%C3%AAs%20em%202018.png)

Na figura 3, pode-se observar a evolução dos pedidos dia a dia no mês de Maio, que foi o mês com o maior número de pedidos como visto anteriormente. Nesse mês, observa-se que o aumento aconteceu no final, particularmente nos dias 26 e 30. 

![](https://github.com/ricardobreis/Text-Mining-Acesso-Info-SP/blob/master/img/An%C3%A1lise%20Explorat%C3%B3ria%20-%20Pedidos%20por%20Dia%20em%20Maio%20de%202018.png)

Pode-se observar na figura 4 o comportamento dos pedidos nos 3 órgão selecionados durante o ano de 2018. A SME e SMS aparentemente seguem a mesma lógica da figura 2 com picos por volta do meio do ano e declínio ao final, porém a SPTrans segue um padrão um pouco diferente, com pico em janeiro seguido de um declínio até maio. 

![](https://github.com/ricardobreis/Text-Mining-Acesso-Info-SP/blob/master/img/An%C3%A1lise%20Explorat%C3%B3ria%20-%20Pedidos%20por%20M%C3%AAs%20em%202018%20-%20Educa%C3%A7%C3%A3o%2C%20Sa%C3%BAde%20e%20Transporte.png)

## Text Mining

Inicialmente , o campo dc_pedido contendo os pedidos de acesso à informação foi separado em tokens e retirada as stop words da língua portuguesa, porém notou-se algumas palavras que não adicionavam significância à análise, logo foram retiradas também junto das stop words.

![](https://github.com/ricardobreis/Text-Mining-Acesso-Info-SP/blob/master/img/stopwordsadicionadas.png)

Após o processo de tokenização e remoção de stop words, gerou-se um ranking top 30 de palavras mais utilizadas nos pedidos. É possível notar que as palavras se relacionam com pedidos de dados sobre servidores, servidores comissionados, dados da cidade e região e citação de lei possivelmente para embasar alguma solicitação.

![](https://github.com/ricardobreis/Text-Mining-Acesso-Info-SP/blob/master/img/Text%20Mining%20-%20TOP%2030%20-%20Contagem%20de%20Palavras%20Geral.png)

Na figura 7 podem-se observar as palavras de forma mais clara da sua importância.

![](https://github.com/ricardobreis/Text-Mining-Acesso-Info-SP/blob/master/img/Text%20Mining%20-%20Top%2030%20World%20Cloud.png)

Partindo-se para uma análise mais aprofundada dos órgãos selecionados, fez-se um top 10 de palavras mais utilizadas. Na educação, observa-se um interesse sobre números e dados de ensino nas escolas, já na saúde há um interesse em unidades básicas de saúde, enquanto que nos transportes aparentemente deseja-se saber sobre ônibus e passageiros. Com a superficialidade dessa análise, optou-se por partir para um estudo de bigramas, trigramas e TF-IDF com o intuito de aprofundar e pesquisa e retirar insights sobre o que a população está interessada em saber do estado.

![](https://github.com/ricardobreis/Text-Mining-Acesso-Info-SP/blob/master/img/Text%20Mining%20-%20TOP%2010%20-%20Contagem%20de%20Palavras%20-%20SME%2C%20SMS%20e%20SPTrans.png)

Analisando a figura 9, já é possível observar alguns tópicos surgindo, principalmente no órgão SPTrans onde identificamos 3 bigramas associados diretamente com abusos sexuais e 1 sobre bilhete único. Já na SME nota-se interesse em educação infantil e fundamental, enquanto que na SMS não surgiu nenhum tópico além do comentado anteriormente. 

![](https://github.com/ricardobreis/Text-Mining-Acesso-Info-SP/blob/master/img/An%C3%A1lise%20de%20Bigramas%20-%20TOP%2010%20-%20Contagem%20de%20Bigramas%20-%20Educa%C3%A7%C3%A3o%2C%20Sa%C3%BAde%20e%20Transporte.png)

Fazendo-se uma análise TF-IDF dos bigramas, puderam-se corroborar os assuntos citados no parágrafo anterior para o SPTrans e SME, enquanto que na SMS, já surgem alguns temas que aparentemente são de interesse da população, como NTCSSS (Núcleo Técnico de Contratação de Serviço de Saúde) e contratos.

![](https://github.com/ricardobreis/Text-Mining-Acesso-Info-SP/blob/master/img/An%C3%A1lise%20TF-IDF%20de%20Bigramas%20-%20An%C3%A1lise%20TF-IDF%20-%20Educa%C3%A7%C3%A3o%2C%20Sa%C3%BAde%20e%20Transporte.png)

Partindo-se para a análise de trigramas, além dos temas já citados anteriormente, na SME aparecem dúvidas sobre servidores comissionados e como proceder ou recorrer sobre algo. Na SPTrans, o tema de abusos sexuais aprece fortemente como o principal novamente, porém já se nota citações sobre servidores comissionados, zonas e tempo indicado em meses. Na SMS surgiu um tópico sobre dados abertos nos trigramas “dados abertos atenciosamente” e “abertos atenciosamente rede”, indicando a causa de citações a formatos de dados como csv, planilha e xlx.

![](https://github.com/ricardobreis/Text-Mining-Acesso-Info-SP/blob/master/img/an%C3%A1lise%20de%20Trigramas%20-%20Contagem%20de%20Trigramas%20-%20Educa%C3%A7%C3%A3o%2C%20Sa%C3%BAde%20e%20Transporte.png)

A análise TF-IDF de trigramas reforça todas as análises feitas anteriores, adicionando o tema de fraudes à SPTrans.

![](https://github.com/ricardobreis/Text-Mining-Acesso-Info-SP/blob/master/img/An%C3%A1lise%20TF-IDF%20de%20Trigramas%20-%20An%C3%A1lise%20TF-IDF%20-%20Educa%C3%A7%C3%A3o%2C%20Sa%C3%BAde%20e%20Transporte.png)





