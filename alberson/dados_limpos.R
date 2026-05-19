# Script para geração de base de dados simulada

set.seed(123)

n_rows <- 100

# geração de dados limpos
id <- 1:n_rows
nome <- paste0("Cliente_", 1:n_rows)
idade <- sample(18:80, n_rows, replace = TRUE)
renda <- round(rnorm(n_rows, mean = 5000, sd = 1500), 2)
observacao <- sample(c("Cliente fiel", "Ligar novamente", "Sem problemas", "VIP", "Reclamou do preço"), n_rows, replace = TRUE)

# simulando json
json_extra <- paste0('"{""cidade"": ""Cidade_', sample(1:10, n_rows, replace = TRUE), '"", ""status"": ""ativo""}"')

# cabeçalho
linhas <- character(n_rows + 1)
linhas[1] <- "id,nome,idade,renda,notas,json_extra"

for (i in seq_len(n_rows)) {
  linhas[i + 1] <- paste(id[i], nome[i], idade[i], renda[i], observacao[i], json_extra[i], sep = ",")
}
