
#' Convert rdfs to Excel using RdfToExcel
#'
#' `rdf_to_excel()` calls the CADSWES provided RdfToExcel tool for the specified
#' `rdfs`. The RdfToExcelExecutable.exe should be found when searching the Path
#' environment variable, otherwise this function will error.
#'
#' @param rdfs Vector of rdf files. Should end in ".rdf" and exist in the
#'   specified `path`
#'
#' @param path Folder containing the rdf files. This is also where the Excel
#'   files will be created.
#'
#' @param xlsx The Excel file names. If `NULL`, then will use the same file
#'   names as the rdf file names. Otherwise, rename them to names specified
#'   here. If specifying names, this must have the same length as `rdfs` and
#'   each name should end in ".xlsx".
#'
#' @return Invisibly returns the absolute path to all created Excel files.
#'
#' @examples
#' \dontrun{
#' scen_path <- "M:/Shared/CRSS/2020/Scenario/Feb2020_2021,DNF,2007Dems,IG_DCP"
#' rdfs <- c('KeySlots.rdf','SystemConditions.rdf')
#' # will save excel files as KeySlots.xlsx and SystemConditions.xlsx
#' rdf_to_excel(rdfs, scen_path)
#' # or rename to Feb2020_KeySlots.xlsx and Feb2020_SystemConditions.xlsx
#' xlsx <- c("Feb2020_KeySlots.xlsx", "Feb2020_SystemConditions.xlsx")
#' rdf_to_excel(rdfs, scen_path, xlsx)
#' }
#'
#' @export

rdf_to_excel <- function(rdfs, path, xlsx = NULL)
{
  rdf2excel <- find_rdf2excel()
  assert_that(length(path) == 1 && dir.exists(path))
  assert_that(
    all(tools::file_ext(rdfs) == "rdf"),
    msg = "All `rdfs` should have a '.rdf' file extension."
  )

  xlsx <- check_xlsx(xlsx, rdfs)

  # full path to rdfs, and ensure they exist
  rdfs <- normalizePath(file.path(path, rdfs), mustWork = TRUE)
  xlsx <- normalizePath(file.path(path, xlsx), mustWork = FALSE)

  # Run RdfToExcelExecutable -----------------------------------

  for (i in seq_along(rdfs)) {
    message("Starting: ", rdfs[i])

    cmd <- c("-i", rdfs[i], "-o", xlsx[i])

    system2(rdf2excel, args = cmd)
  }

  invisible(xlsx)
}

find_rdf2excel <- function()
{
  rdf2excel <- Sys.which("RdfToExcelExecutable")

  assert_that(
    rdf2excel != "",
    msg = paste0(
      "Could not find RdfToExcelExecutable.exe.\n",
      "Ensure it is in the Path environment variable."
    )
  )

  rdf2excel
}

check_xlsx <- function(xlsx, rdfs)
{
  if (!is.null(xlsx)) {
    # ensure it is the same length as rdfs, and all end in .xlsx
    assert_that(
      length(xlsx) == length(rdfs),
      msg = "`xlsx` should either be NULL, or have the same length as `rdfs`."
    )
    assert_that(
      all(tools::file_ext(xlsx) == "xlsx"),
      msg = "All `xlsx` should have a '.xlsx' file extension."
    )

  } else {
    # all xlsx files will have same name as rdfs
    file_names <- tools::file_path_sans_ext(rdfs)
    xlsx <- paste0(file_names, ".xlsx")
  }

  xlsx
}
