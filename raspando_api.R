#Raspando API's

# Pacotes -----------------------------------------------------------------
library(httr)
library(tidyverse)

# Get the data -------------------------------------------------------------
url <-"https://gateway.plataforma.centauro.com.br/yantar/api/search"

queryString <- list(
  term = "mizuno",
  resultsPerPage = "2",
  page = "1",
  sorting = "relevance",
  scoringProfile = "scoreByRelevance",
  restrictSearch = "true",
  multiFilters = "true"
)

payload <- ""

encode <- "raw"

response <-
  VERB(
    "GET",
    url,
    body = payload,
    add_headers(
      authority = 'gateway.plataforma.centauro.com.br',
      accept_language = 'pt-BR,pt;q=0.9',
      authorization = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6ImZyb250LWVuZCBjZW50YXVybyIsIm5iZiI6MTU4OTkxOTgxMywiZXhwIjoxOTA1NDUyNjEzLCJpYXQiOjE1ODk5MTk4MTN9.YeCTBYcWozaQb4MnILtfeKTeyCwApNgLSOfGeVVM8D0',
      origin = 'https://www.centauro.com.br',
      referer = 'https://www.centauro.com.br/busca?q=mizuno',
      user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'
    ),
    query = queryString,
    accept("application/json, text/plain, */*"),
    
    encode = encode
  )

conteudo<-content(response)

content(response,as = "parsed" , type = "application/json") 

# Wrangling data ----------------------------------------------------------

#ruim
conteudo$products %>% enframe() %>% unnest() %>% View()
  

 produtos <- conteudo$products %>% tibble(produto = .)
 
 names(produtos$produto[[1]])

 produtos %>% 
   unnest_wider(produto) %>% 
   unnest_wider(details) %>% 
   unnest_longer(Categoria) %>% View()

 
 conteudo$products |> str(list.len =3)
 conteudo$products[[1]] |> str(list.len =11)
 
 
  purrr::map(conteudo$products, "details")
 purrr::map_dfr(conteudo$products, magrittr::extract, c("id", "name",
                                                    "price", "status",
                                                    "url")) 
 
 conteudo$products %>% {
   tibble(
     id = map_chr(., "id")
   )
 }
 
                