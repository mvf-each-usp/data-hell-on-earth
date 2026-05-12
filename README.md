# hell-data-on-earth
Apresentação para a Série `R_Brasil |> bate::papo()`

Este repositório agora contém uma apresentação em **Quarto Markdown** para gerar
slides HTML sobre problemas comuns na importação e leitura de dados textuais,
com foco em:

- encoding (`ASCII`, `UTF-8`, `UTF-16`, `Windows-1252` e codepages);
- fim de linha (`LF`, `CRLF` e `CR`);
- `BOM`;
- ordenação/collation em diferentes encodings;
- sinais típicos de corrupção textual ao importar dados.

## Estrutura

- `/index.qmd`: apresentação principal em Quarto
- `/_quarto.yml`: configuração do projeto
- `/styles.css`: ajustes visuais dos slides
- `/react-demo.html`: componente ReactJS embutido nos slides

## Como gerar os slides

Com o Quarto instalado:

```bash
cd /home/runner/work/hell-data-on-earth/hell-data-on-earth
quarto render
```

Ou, para abrir em modo interativo:

```bash
cd /home/runner/work/hell-data-on-earth/hell-data-on-earth
quarto preview
```
