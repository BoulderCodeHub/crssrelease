
#' Rename Excel Files to Include Scenario Name
#'
#' `rename_excel_files()` inserts a scenario name to the beginning of an the
#' existing file name.
#'
#' @param ifolder Top level folder(s) to find the excel files.
#'
#' @param files Vector of file(s) to rename.
#'
#' @param insert_name By default (if this is `NULL`), the top level folder name
#'   will be inserted into the current file name. If this parameter is
#'   specified, it will be used instead of the top level folder. If it is not
#'   `NULL`, it must be the same length as the number of files specified by
#'   `ifolder`.
#'
#' @param sep The character used to seperate `insert_name` from the current file
#'   name.
#'
#' @return Invisibly return a n x 2 matrix with the original file names in the
#'   first column and the new file names in the second column.
#'
#' @export

rename_excel_files <- function(files, ifolder, insert_name = NULL, sep = "-")
{
  assert_that(all(dir.exists(ifolder)))
  file_folder_combo <- expand.grid(ifolder, files)
  all_files <- file.path(file_folder_combo[,1], file_folder_combo[,2])
  assert_that(all(file.exists(all_files)))

  if (!is.null(insert_name))
    assert_that(length(insert_name) == length(ifolder))

  ofiles <- c()

  for (i in seq_along(ifolder)) {

    ff <- ifolder[i]
    old_files <- file.path(ff, files)

    if (is.null(insert_name)) {
      tmp_name <- basename(ifolder)
    } else {
      tmp_name <- insert_name[i]
    }

    # now loop through all files, and rename them

    new_files <- file.path(ff, paste0(tmp_name, sep, files))

    file.rename(old_files, new_files)

    ofiles <- rbind(ofiles, cbind(old_files, new_files))
  }

  invisible(ofiles)
}
