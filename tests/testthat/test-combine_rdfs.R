library(RWDataPlyr)

# CAUTION - do not run this test using RStudio "RunTests" button. It will not
# work. Instead, use test_that::test_file(), or devtools::test() to run all
# tests

test_scens <- c("ISM1988_2014,2007Dems,IG,2002", "ISM1988_2014,2007Dems,IG,Most")
scen_path <- "../Scenario"
rdfs <- c("KeySlots.rdf", "SystemConditions.rdf")

# Setup/Teardown -------------------------
ofolder <- "combine_rdfs"
setup(dir.create(ofolder))
teardown(unlink(ofolder, recursive = TRUE))

# combine_rdfs ---------------------------
test_that("combine_rdfs() works", {
  expect_type(
    x <- combine_rdfs(rdfs, test_scens, scen_path, "combine_rdfs"),
    "character"
  )
  exp_files <- normalizePath(file.path(ofolder, rdfs), mustWork = TRUE)
  expect_true(all(x == exp_files))
})

# RWDataPlyr ------------------------------
test_that("manual combination matches exe.", {
  r_comb <- read_rdf(file.path(ofolder, rdfs[1]))
  r1 <- read_rdf(file.path(scen_path, test_scens[1], rdfs[1]))
  r2 <- read_rdf(file.path(scen_path, test_scens[2], rdfs[1]))
  for (slot in rdf_slot_names(r1)) {
    s1 <- rdf_get_slot(r1, slot)
    s2 <- rdf_get_slot(r2, slot)
    s_comb <- rdf_get_slot(r_comb, slot)
    expect_equivalent(s_comb, cbind(s1, s2))
  }
})

# create_combiner_batch_txt ---------------------
test_that("create_combiner_batch_txt() works", {
  crssrelease:::create_combiner_batch_txt(
    c("c:/scen1", "c:/scen2"),
    "rdf.rdf",
    "c:/folder/file.rdf",
    batchDir = ofolder
  )
  expect_true(file.exists(file.path(ofolder,"RdfCombinerBatchControl.txt")))
  ifile <- scan(
    file.path(ofolder, "RdfCombinerBatchControl.txt"),
    what = character(), sep = "\n", quiet = TRUE
  )
  expect_equal(
    ifile,
    c("$c:/folder/file.rdf", "c:/scen1; rdf.rdf", "c:/scen2; rdf.rdf")
  )
})
