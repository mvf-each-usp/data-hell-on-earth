# ############################################################################ #
# extrai mensagens ----
# ### #
# extrai e filtra as mensagens mais interessantes que já escrevi pro R Brasil
# sobre importação dados etc
# ############################################################################ #

# carregando pacotes ----
library(tidyverse)
library(rvest, warn.conflicts = FALSE)
# library(multidplyr)

# configurando paralelização ----
# ## no multidplyr ----
# cluster.multidplyr <- multidplyr::new_cluster(6)

# lendo tudo ----

system.time(
  list.files(
    path = "data", 
    pattern = "*.html",
    recursive = TRUE, 
    full.names = TRUE
  ) |> 
    # head(1) |> 
    map(
      \(nome) {
        library(rvest)
        library(xml2)
        read_html(nome) |>
          html_elements("body") |>
          html_elements(".history") |>
          html_elements("div[class~=\"default\"]") # |> 
        # map(list)
      },
      .progress = TRUE
    ) |> 
    map(
      \(node) {
        library(rvest)
        library(xml2)
        tibble(
          id =
            node |>
            html_attr("id"),
          classes =
            node |>
            html_attr("class"),
          data =
            node |>
            html_element(".date") |>
            html_attr("title"),
          autor =
            node |>
            html_element(".from_name") |>
            html_text(),
          texto =
            node |>
            html_element(".text") |>
            html_text(),
          links =
            node |>
            html_element(".text") |>
            html_element("a[href]") |> 
            html_attr("href"),
          reply.to =
            node |> 
            html_element(".reply_to") |> 
            html_element("a[href]") |> 
            html_attr("href"),
          mídia.class =
            node |> 
            html_element(".media") |> 
            html_attr("class"),
          tam.mídia = 
            node |> 
            html_element(".media") |> 
            html_element(".details") |> 
            html_text()
        )
      },
      .progress = TRUE
    ) |> 
    list_rbind() |> 
    mutate(
      id = 
        id |> 
        str_remove("message") |> 
        as.integer(),
      data = 
        data |> 
        lubridate::dmy_hms(),
      across(
        autor:texto,
        str_trim
      ),
      continuação =
        classes |> 
        str_detect("joined"),
      tam.texto = 
        texto |> 
        nchar(),
      reply.to = 
        reply.to |> 
        str_remove("#go_to_message") |> 
        as.integer(),
      anexo = 
        mídia.class |> 
        str_extract("media_.*") |> 
        str_remove("media_"),
      tam.anexo = 
        tam.mídia |> 
        str_remove(".*, ")
    ) |> 
    fill(autor) |> 
    select(
      id,
      data,
      autor,
      texto,
      tam.texto,
      continuação,
      reply.to,
      links,
      anexo,
      tam.anexo
    ) |> 
    saveRDS("data/msgs.rds")
)

msgs |> 
  filter(id == 198276) |> 
  pull(texto) |> 
  str_detect("\n")
