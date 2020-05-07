#' Create a template for documenting changes to CRSS
#'
#' `crss_changes_template()` creates a template for documenting the changes to
#' CRSS since the last release. The template is in RMarkdown and can then be
#' knit to pdf, and provided with the CRSS package.
#'
#' @param filename The name of the file to create. If `NULL` will be
#'   crss_changes_template.Rmd. If specified can have a .Rmd extension, and if
#'   it does not, it will be added.
#'
#' @param path Where to create the file. If `NULL` will be in the current
#'   directory.
#'
#' @return Invisibly returns the full file name if successful. Otherwise returns
#'   `FALSE`.
#'
#' @examples
#' \dontrun{
#' # create January2020.Rmd in the current directory
#' crss_changes_template("January2020")
#' # create crss_changes_template.Rmd in C:/test
#' crss_changes_template(path = "C:/test")
#' }
#'
#' @export

crss_changes_template <- function(filename = NULL, path = NULL)
{
  if (is.null(filename))
    filename <- "crss_changes_template.Rmd"
  else {
    assert_that(length(filename) == 1)
    if (tolower(tools::file_ext(filename)) != "rmd")
      filename <- paste0(filename, ".Rmd")
  }

  if (is.null(path))
    path <- normalizePath(".")
  else
    assert_that(length(path) == 1 && dir.exists(path))

  new_file <- file.path(path, filename)
  template <- system.file(
    "template", "crss_changes_template.Rmd",
    package = "crssrelease"
  )
  x <- file.copy(template, new_file)

  if (x)
    x <- new_file

  invisible(x)
}
