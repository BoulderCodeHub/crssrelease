#' Combine rdf files for a set of scenarios
#'
#' `combine_rdfs()` creates one rdf file containing data for that rdf file from
#' multiple scenarios.
#'
#' @param rdfs A vector of rdf(s) to combine. There will be one rdf file
#'   created for each provided rdf file.
#'
#' @param scenarios A vector of scenarios. The specified `rdf` will be combined
#'   from all `scenarios`.
#'
#' @examples
#' \dontrun{
#' scens <- "Apr2020_2021,DNF,2007Dems,IG_DCP,MTOM_Most
#' rdfs <- paste0(c('KeySlots','Flags','SystemConditions','OWDAnn','Res','xtraRes',
#'                  "CRSPPowerData", "LBEnergy", "LBDCP", "UBDO"),'.rdf')
#' scen_path <- 'M:/Shared/CRSS/2020/Scenario
#' combine_rdfs(rdfs, scens, scen_path)
#' }

combine_rdfs <- function(rdfs, scenarios, path)
{
  # path to the RiverWareBatchRdfCombiner.exe
  batchPath <- system.file("bin", package = "crssrelease")

  # call the combiner for all rdfs
  # callCombinerByRdf(rdf, fNames, batchDir)
  lapply(
    as.list(rdfs),
    callCombinerByRdf,
    fNames = file.path(path, scenarios),
    batchDir = batchPath
  )
}

library(stringr)
library(data.table)
library(assertthat)

#' Create the batch text file used by the Combiner Executable
#'
#' @param fNames The folder names (full path)
#' @param rdf The rdf file to combine together
#' @param oFile A full path to the new combined rdf file. Should end in .rdf
#' @param batchDir The folder to create the batch text file in
#' @noRd
createCombinerBatchTxt <- function(fNames, rdf, oFile, batchDir)
{
  combineFiles <- paste0(fNames,'; ',rdf)
  combineFiles <- matrix(c(paste0('$',oFile), combineFiles), ncol = 1)
  data.table::fwrite(as.data.frame(combineFiles), file.path(batchDir,'RdfCombinerBatchControl.txt'),
                     quote = F, col.names = F, row.names = F)
}

#' Create the batch text file, and then call the Rdf Combiner
#'
#' @param rdf The rdf file to combine together
#' @param fNames The folder names (full path)
#' @param batchDir The folder to create the batch text file in (also the
#'   directory to create the rdf in)
#'
#' @return TRUE if successful
#' @noRd
callCombinerByRdf <- function(rdf, fNames, batchDir)
{
  assert_that(
    all(file.exists(fNames)),
    msg = "At least one of the fNames does not exist."
  )

  oFile <- file.path(batchDir,rdf)
  message(paste('Creating batch text file for',rdf,'...'))
  createCombinerBatchTxt(fNames = fNames, rdf = rdf, oFile = oFile, batchDir = batchDir)
  # the executable has to be called from the directory the batch file is in
  owd <- getwd()
  setwd(batchDir)
  message(paste('Starting RDF Combiner for',rdf,'...'))
  system2(file.path(batchDir,'RiverWareBatchRdfCombiner'))
  setwd(owd)
  return(TRUE)
}
