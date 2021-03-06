% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rename_excel_files.R
\name{rename_excel_files}
\alias{rename_excel_files}
\title{Rename Excel Files to Include Scenario Name}
\usage{
rename_excel_files(files, ifolder, insert_name = NULL, sep = "-")
}
\arguments{
\item{files}{Vector of file(s) to rename.}

\item{ifolder}{Top level folder(s) to find the excel files.}

\item{insert_name}{By default (if this is \code{NULL}), the top level folder name
will be inserted into the current file name. If this parameter is
specified, it will be used instead of the top level folder. If it is not
\code{NULL}, it must be the same length as the number of folders specified in
\code{ifolder}.}

\item{sep}{The character used to seperate \code{insert_name} from the current file
name.}
}
\value{
Invisibly return a n x 2 matrix with the original file names in the
first column and the new file names in the second column.
}
\description{
\code{rename_excel_files()} inserts a scenario name to the beginning of an the
existing file name.
}
