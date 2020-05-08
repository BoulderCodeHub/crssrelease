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
#' @param scen_path Top level directory of all the specified `scenarios`.
#'
#' @param out_path Where to save the combined rdfs.
#'
#' @return Invisibly returns a vector of the file names of all the rdfs that
#'   were created.
#'
#' @examples
#' \dontrun{
#' scens <- "Apr2020_2021,DNF,2007Dems,IG_DCP,MTOM_Most"
#' rdfs <- paste0(c('KeySlots','Flags'),'.rdf')
#' scen_path <- 'M:/Shared/CRSS/2020/Scenario'
#' x <- combine_rdfs(rdfs, scens, scen_path, "C:/test")
#'
#' # the following would be c(TRUE, TRUE)
#' x == c("C:/test/KeySlots.rdf", "C:/test/Flags.rdf")
#' }
#'
#' @export

combine_rdfs <- function(rdfs, scenarios, scen_path, out_path)
{
  assert_that(is.character(rdfs) && length(rdfs) >= 1)
  assert_that(is.character(scenarios) && length(scenarios) >= 1)
  assert_that(dir.exists(scen_path))
  assert_that(dir.exists(out_path))

  scen_folders <- file.path(scen_path, scenarios)
  assert_that(all(dir.exists(scen_folders)))

  # convert paths to absolute paths (if they were relative)
  scen_folders <- normalizePath(scen_folders)
  out_path <- normalizePath(out_path)

  # path to the RiverWareBatchRdfCombiner.exe
  batch_path <- system.file("exec", package = "crssrelease")

  # create area to work in tempdir
  temp_dir <- file.path(tempdir(TRUE), "crssrelease")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE))

  # copy the executable to this directory
  file.copy(
    file.path(batch_path, "RiverWareBatchRdfCombiner.exe"),
    file.path(temp_dir, "RiverWareBatchRdfCombiner.exe")
  )

  batch_path <- temp_dir

  # call the combiner for all rdfs
  # call_combiner_by_rdf(rdf, fNames, batchDir)
  rdfs_created <- lapply(
    as.list(rdfs),
    call_combiner_by_rdf,
    fNames = scen_folders,
    batchDir = batch_path,
    out_path = out_path
  )

  rdfs_created <- simplify2array(rdfs_created)

  any_errors <- which(rdfs_created == "FALSE")
  if (length(any_errors) > 0)
    warning(length(any_errors), " rdfs were not properly created")

  invisible(rdfs_created)
}

#' Create the batch text file used by the Combiner Executable
#'
#' @param fNames The folder names (full path)
#' @param rdf The rdf file to combine together
#' @param oFile A full path to the new combined rdf file. Should end in .rdf
#' @param batchDir The folder to create the batch text file in
#' @noRd
create_combiner_batch_txt <- function(fNames, rdf, oFile, batchDir)
{
  combineFiles <- paste0(fNames, '; ', rdf)
  combineFiles <- matrix(c(paste0('$',oFile), combineFiles), ncol = 1)
  write(
    combineFiles,
    file.path(batchDir,'RdfCombinerBatchControl.txt'),
    ncolumns = 1
  )
}

#' Create the batch text file, and then call the Rdf Combiner
#'
#' @param rdf The rdf file to combine together
#' @param fNames The folder names (full path)
#' @param batchDir The folder to create the batch text file in (also the
#'   directory to create the rdf in)
#' @param out_path Where to save the combined rdf, also full path.
#'
#' @return TRUE if successful
#' @noRd
call_combiner_by_rdf <- function(rdf, fNames, batchDir, out_path)
{
  assert_that(
    all(dir.exists(fNames)),
    msg = "At least one of the fNames does not exist."
  )

  oFile <- normalizePath(file.path(out_path, rdf), mustWork = FALSE)
  message(paste('Creating batch text file for', rdf, '...'))
  create_combiner_batch_txt(fNames, rdf, oFile, batchDir)
  # the executable has to be called from the directory the batch file is in
  owd <- getwd()
  setwd(batchDir)
  on.exit(setwd(owd))
  message(paste('Starting RDF Combiner for',rdf,'...'))
  comb_out <- system2('RiverWareBatchRdfCombiner.exe', stdout = TRUE, invisible = FALSE)

  # check that the file was created,
  # TODO: the output from the executable. Might provide more useful info.
  if (file.exists(oFile))
    return(oFile)
  else
    return(FALSE)
}
