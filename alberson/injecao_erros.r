# script para injeção de erros

source("dados_limpos.R")

# sem renda renda
linhas[16] <- paste(id[15], nome[15], idade[15], observacao[15], json_extra[15], sep = ",")

# aspas descasadas
linhas[26] <- paste(id[25], paste0('"', nome[25]), idade[25], renda[25], observacao[25], json_extra[25], sep = ",")

# separador faltando entre idade e renda
linhas[36] <- paste(id[35], nome[35], paste0(idade[35], renda[35]), observacao[35], json_extra[35], sep = ",")

# quebra acidental no texto
linhas[46] <- paste(id[45], nome[45], idade[45], renda[45], "Quebrou\na linha", json_extra[45], sep = ",")

# mismatch de chaves no JSON
bad_json <- paste0('"{""cidade"": ""Cidade_X"", ""status"": ""ativo"""')
linhas[56] <- paste(id[55], nome[55], idade[55], renda[55], observacao[55], bad_json, sep = ",")

# probelma de encoding
linha_latin1 <- 66
observacao[65] <- "Atenção: Ação judicial (procon) - Válido até março"
linhas[linha_latin1] <- paste(id[65], nome[65], idade[65], renda[65], observacao[65], json_extra[65], sep = ",")


f <- file("dados.csv", "wb")

for (i in seq_along(linhas)) {
  # escolhe aleatoriamente o tipo de quebra de linha
  quebra <- if (runif(1) > 0.5) "\r\n" else "\n"

  # salva a linha 66 em Latin-1 (resto em UTF-8)
  if (i == linha_latin1) {
    # Tenta converter para latin1
    linha_bytes <- charToRaw(
      iconv(paste0(linhas[i], quebra), from = "UTF-8", to = "latin1")
    )
    writeBin(linha_bytes, f)
  } else {
    linha_bytes <- charToRaw(enc2utf8(paste0(linhas[i], quebra)))
    writeBin(linha_bytes, f)
  }
}

close(f)
