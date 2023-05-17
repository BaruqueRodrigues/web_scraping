## Automatização de download--------------------------------

url <- "https://www.portaltransparencia.gov.br/download-de-dados/despesas-execucao/201803"
destfile <- "201803.zip"

df_url<- data.frame(ano = rep(2014:2020, 12),
           mes = rep(c("01","02","03","04",
                       "05","06","07","08",
                       "09","10","11","12"), 7)) %>% tibble() %>%
  mutate(url = "https://www.portaltransparencia.gov.br/download-de-dados/despesas-execucao/",
         url_completa = paste0(url, ano, mes),
         diretorio = "data/CNEN/despesas_orcamentarias_cnen/")
df_url <-df_url[1:5,]
#
temp <- tempfile()
#download funcionou mas está armazendo na temp
Map(function(u, d) download.file(u, d, mode="wb"), df_url$url_completa, basename(df_url$url_completa))

download.file(url,temp)
temp2 <- tempfile()
despesas_unz <- unzip(temp, exdir = temp2)
dir_zip<-list.files("data/CNEN/despesas_orcamentarias_cnen/",full.names = T)


walk(dir_zip, ~ unzip(zipfile = str_c("data/CNEN/despesas_orcamentarias_cnen/", .x),
                         exdir = str_c("data/CNEN/desp_orc_csv/", .x)))
#
filenames <- list.files(path = "data/CNEN/desp_orc_csv/",
                        full.names = TRUE)

library(tidyverse)
cnen_orcamentarios <- purrr::map_df(filenames,
                            ~readr::read_delim(.x,
                                               delim = ";",
                                               locale = locale(encoding = "latin1"),
                                               col_types = cols(
                                                 `Código Unidade Orçamentária` = col_character(),
                                                 `Código Subfução` = col_character(),
                                                 `Código Autor Emenda` = col_character(),
                                                 `Código Ação` = col_character(),
                                                 `Código Categoria Econômica`= col_character(),
                                                 `Código Elemento de Despesa` = col_character(),
                                                 `Código Função` = col_character(),
                                                 `Código Gestão` = col_character(),
                                                 `Código Grupo de Despesa` =col_character(),
                                                 `Código Localizador` = col_character(),
                                                 `Código Modalidade da Despesa` = col_character(),
                                                 `Código Plano Orçamentário`= col_character(),
                                                 `Código Programa Governo` = col_character(),
                                                 `Código Subtítulo` =  col_character(),
                                                 `Código Unidade Gestora`=  col_character(),
                                                 `Código Órgão Subordinado`=  col_character(),
                                                 `Código Órgão Superior`=  col_character())
                                              )) %>%
  janitor::clean_names() %>%
  filter(nome_orgao_subordinado == "Comissão Nacional de Energia Nuclear") %>%
  tibble()

cnen_orcamentarios_res <- cnen_orcamentarios %>%
  filter(codigo_acao %in% c("12P1", "13CN", "13CM", "20UY",
                            "20UX", "215N", "2B32", "6147")) %>%
  mutate(ano_e_mes_do_lancamento = lubridate::ym(ano_e_mes_do_lancamento),
         ano = lubridate::year(ano_e_mes_do_lancamento),
         valor_pago_r = as.numeric(stringr::str_replace_all(
           stringr::str_replace_all(valor_pago_r, "[.$]", ""), "[,]", "." )),) %>%
  relocate(codigo_acao, ano, everything())



cnen_orcamentarios_res <- cnen_orcamentarios_res %>%
  select(codigo_acao,  data_incio =ano_e_mes_do_lancamento,
         nome_acao,valor_pago_r, ano) %>%
  group_by(codigo_acao, nome_acao,
           ano) %>%
  summarise(valor_contratado = sum(valor_pago_r)) %>%
  ungroup()

cnen_orcamentarios_res <- cnen_orcamentarios_res%>%
  mutate(data_inicio = lubridate::make_date(year = ano, "01", "01"),
         data_limite = lubridate::make_date(year = ano, "12", "31"),
         instituicao = "CNEN",
         fonte_de_dados = "CNEN",
         duracao_dias = lubridate::time_length(data_limite - data_inicio, "days"),
         id = paste("CNEN", codigo_acao, 1:nrow(cnen_orcamentarios_res),sep = "_"),
         titulo_projeto = paste0("guarda-chuva_", codigo_acao),
         categoria = "4.9") %>%
  ETLEBP::func_a(id, data_inicio, data_limite, valor_contratado)

cnen_orcamentarios_res <- cnen_orcamentarios_res %>%
  mutate(
         nome_agente_financiador = NA,
         natureza_agente_financiador = NA,
         modalidade_financiamento = NA,
         nome_agente_executor = "CNEN",
         natureza_agente_executor = NA,
         uf_ag_executor = NA,
         regiao_ag_executor = NA,
         natureza_agente_executor = NA,
         natureza_financiamento = NA,
         modalidade_financiamento = "não-reembolsavel",
         status_projeto = NA)

cnen_orcamentarios_res <- cnen_orcamentarios_res %>%
  select(
    id,
    fonte_de_dados,
    data_assinatura = data_inicio,
    data_limite,
    duracao_dias,
    titulo_projeto,
    status_projeto,
    valor_contratado,
    valor_executado_2013_2025 = gasto_2013_2020,
    nome_agente_financiador,
    natureza_agente_financiador,
    modalidade_financiamento,
    nome_agente_executor,
    natureza_agente_executor,
    uf_ag_executor,
    regiao_ag_executor,
    natureza_agente_executor,
    natureza_financiamento,
    modalidade_financiamento,
    valor_executado_2013 = gasto_2013,
    valor_executado_2014 = gasto_2014,
    valor_executado_2015 = gasto_2015,
    valor_executado_2016 = gasto_2016,
    valor_executado_2017 = gasto_2017,
    valor_executado_2018 = gasto_2018,
    valor_executado_2019 = gasto_2019,
    valor_executado_2020 = gasto_2020,
    valor_executado_2021 = gasto_2021,
    valor_executado_2022 = gasto_2022,
    valor_executado_2023 = gasto_2023,
    valor_executado_2024 = gasto_2024,
    valor_executado_2025 = gasto_2025,
        ) %>%
  dplyr::mutate(
    categorias =
      case_when(
        str_detect(id, "CNEN_12P1") == TRUE ~ 4.1,
        str_detect(id, "CNEN_13CM") == TRUE ~ 4.1,
        str_detect(id, "CNEN_13CN") == TRUE ~ 4.2,
        str_detect(id, "CNEN_20UY") == TRUE ~ 7.2,
        str_detect(id, "CNEN_20UX") == TRUE ~ 7.3,
        str_detect(id, "CNEN_215N") == TRUE ~ 7.3,
        str_detect(id, "CNEN_2B32") == TRUE ~ 4.9,
        str_detect(id, "CNEN_6147") == TRUE ~ 4.9
      )
  )



cnen <- ETLEBP::cria_base_intermediaria_cnen()

cnen_final <- rbind(cnen, cnen_orcamentarios_res)

writexl::write_xlsx(cnen_final, "cnen_interm_final.xlsx")

