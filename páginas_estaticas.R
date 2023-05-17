# Raspando Dados de Páginas Estáticas

# Pacotes ---------------------------------------------------------
library(tidyverse)
library(rvest) # auxílio para raspagens de dados

# páginas estáticas -------------------------------------------------------

## Caso 1 dados já tabulados

# url que rasparemos
url <- "https://pt.wikipedia.org/wiki/Lista_de_pa%C3%ADses_por_popula%C3%A7%C3%A3o"

url |>
  rvest::read_html() |> # função que executa a leitura do conteudo html ou xml da URL
  rvest::html_table() # função que extrai as tabelas da url em formato tibble

### Exemplo 2 - Probabilidade de um time da série A vencer o jogo.

url <- "https://chancedegol.com.br/br22.htm"

url |>
  rvest::read_html() |> 
  rvest::html_table() |>
  purrr::pluck(7) 

### Exemplo 3 - caso dos dados ficarem aninhados
url |>
  rvest::read_html() |> 
  rvest::html_table() |>
  purrr::pluck(2) %>% View()

# Manipulação dos Dados

url |>
  rvest::read_html() |> 
  rvest::html_table() |>
  purrr::pluck(2) |>
  dplyr::slice(57:67) |>
  dplyr::select(X1:X6) |>
  janitor::row_to_names(row_number = 1)

## Caso 2 - Transformando dados não estruturados em tabelas - Dados da Amazon

url <- "https://www.amazon.com.br/s?k=anilhas+olimpica&dc&__mk_pt_BR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=3G7N1VMRIZIDT&sprefix=anilhas+olimipica%2Caps%2C166&ref=a9_sc_1"

# Capturando o Título do Anúncio
url |>
  read_html() |>
  html_nodes(".s-line-clamp-4") |>
  html_text()

# Capturando o preço
url |>
  read_html() |>
  html_nodes(".a-price-whole") |>
  html_text()

# Capturando todo o anúncio  
url |>
  read_html() |>
  html_nodes('.s-card-border' ) |>
  html_text()

# E aí, como lidar com o problema.

# Mandrakagem pra raspar corretamente.
anuncio_amazon <- url[1] |>
  read_html() |>
  html_nodes('.s-card-border' ) 

tibble(nome = anuncio_amazon |> html_node(".s-line-clamp-4") |> html_text(trim = T),
           valor = anuncio_amazon |> html_node(".a-price-whole") |> html_text(trim = T)) %>% View()

## Caso 3 - Iterando tudo isso pra raspar várias páginas.

# Capturamos a url
url <- "https://www.amazon.com.br/s?k=whey+protein&page=2&__mk_pt_BR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&qid=1656355614&ref=sr_pg_2"

#quebramos a url em etapas estaticas
url_pt_1 <- "https://www.amazon.com.br/s?k=whey+protein&page="

url_pt_2 <- "&__mk_pt_BR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=Q1X7R7FNY9U7&qid=1656354306&sprefix=whey+prote%2Caps%2C173&ref=sr_pg_"

# e em itens que sofrem variação
url_iteracao <- 1:7

#concatenamos em uma série de strings
url <- paste0(url_pt_1, url_iteracao, url_pt_2, url_iteracao)


#Executamos a interação
anuncios_amazon_df <- map_dfr(url, function(url_alvo){
  anuncio_amazon <- url_alvo |>
    read_html() |>
    html_nodes('.s-card-border' ) 
  
  anuncios_amazon_df<- tibble(nome = anuncio_amazon |> html_node(".s-line-clamp-4") |> html_text(trim = T),
         valor = anuncio_amazon |> html_node(".a-price-whole") |> html_text(trim = T))
  
  
})


## Caso 4 - Raspando texto

url <- "https://www.amazon.com.br/Novo-Echo-Dot-4%C2%AA-gera%C3%A7%C3%A3o/product-reviews/B084DWCZY6/ref=cm_cr_getr_d_paging_btm_next_4?ie=UTF8&reviewerType=all_reviews&pageNumber=4"

url |> read_html() |>
  html_nodes(".celwidget") |> html_text() |> chuck(15)
