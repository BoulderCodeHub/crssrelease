# setup/teardown
fpath <- "../rename_excel"
scens <- c("ISM1988_2014,2007Dems,IG,2002", "ISM1988_2014,2007Dems,IG,Most")
scen_path <- file.path(fpath, "Scenario", scens)

setup(unzip("../rename_excel.zip", exdir = ".."))
teardown(unlink(fpath, recursive = TRUE))

# rename_excel_files() -----------------------
x1 <- c("KeySlots.xlsx", "SystemConditions.xlsx", "Flags.xlsx")

test_that("rename_excel_files() works.", {
  expect_is(x <- rename_excel_files(x1, scen_path), "matrix")
  expect_equal(dim(x), c(6, 2))
  expect_true(all(file.exists(x[,2])))
  expect_true(
    all(file.exists(file.path(scen_path[1], paste0(scens[1], "-", x1))))
  )
  expect_true(
    all(file.exists(file.path(scen_path[2], paste0(scens[2], "-", x1))))
  )

  # delete the unzipped folder, unzip it, and rename again with some other
  # value added in besides the folder name
  unlink(fpath, recursive = TRUE)
  unzip("../rename_excel.zip", exdir = "..")

  expect_is(
    x <- rename_excel_files(x1, scen_path, insert_name = c("a", "b"), sep = "_"),
    "matrix"
  )
  expect_equal(dim(x), c(6, 2))
  expect_true(all(file.exists(x[,2])))
  expect_true(
    all(file.exists(file.path(scen_path[1], paste0("a_", x1))))
  )
  expect_true(
    all(file.exists(file.path(scen_path[2], paste0("b_", x1))))
  )
})
