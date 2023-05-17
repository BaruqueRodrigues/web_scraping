#texto
library(tidyverse)

txt_reddit <- read_csv("txt_reddit.txt", col_names = FALSE)

txt_reddit <- txt_reddit %>% mutate(index = rep(c("votes", "titulo",
                                                   "descricao", "interacao"), 26)) %>% 
  pivot_wider(names_from = index, values_from = X1) %>%
  unnest() %>% 
  mutate(fonte_noticias = str_extract(titulo ,"\\(([\\w\\.]+)\\)"),
         n_comentarios = str_extract(interacao, "[\\d?]+\\s+comentários"),
         tempo_de_vida = str_extract(descricao, "submitted+\\s+[\\d?]+\\s+[\\w]+"),
         autor = str_extract(descricao, "ago\\sby\\s[\\w]+"))

txt_reddit %>%
  relocate(votes, titulo, interacao, n_comentarios, tempo_de_vida, autor, fonte_noticias) %>% 
  select(-descricao, -interacao) %>%
  mutate(n_comentarios = as.numeric(str_extract(n_comentarios, "[\\d?]")),
         tempo_de_vida = str_remove(tempo_de_vida, "submitted "),
         autor = str_remove(autor, "ago by "))


