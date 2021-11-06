bookdown::render_book(
  input = "index.Rmd", 
  output_format = "bookdown::html_document2", 
  clean = FALSE, envir = parent.frame(), 
  clean_envir = !interactive(),
  output_dir = "docs", new_session = NA, 
  preview = TRUE, config_file = "_bookdown.yml"
)

######################################################
##################### Esto está en revisión ##########
######################################################
devtools::install_github("gadenbuie/cleanrmd")
bookdown::render_book(
  input = "index.Rmd", 
  output_format = "cleanrmd::html_document_clean", 
  clean = FALSE, envir = parent.frame(), 
  clean_envir = !interactive(),
  output_dir = "docs", new_session = NA, 
  preview = TRUE, config_file = "_bookdown.yml"
)
