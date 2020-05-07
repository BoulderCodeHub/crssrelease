
test_scens <- c("ISM1988_2014,2007Dems,IG,2002", "ISM1988_2014,2007Dems,IG,Most")
scen_path <- "../Scenario"
rdfs <- c("KeySlots.rdf", "SystemConditions.rdf")
p1 <- file.path(scen_path, test_scens[1])
p2 <- file.path(scen_path, test_scens[2])


# teardown --------------------
# in p1 and p2, delete all .xlsx and .log files
teardown({
  f1 <- list.files(p1)
  f2 <- list.files(p2)
  i1 <- which(tools::file_ext(f1) == "xlsx")
  i2 <- which(tools::file_ext(f1) == "log")
  file.remove(file.path(p1, f1[i1]))
  file.remove(file.path(p1, f1[i2]))
  i1 <- which(tools::file_ext(f2) == "xlsx")
  i2 <- which(tools::file_ext(f2) == "log")
  file.remove(file.path(p2, f2[i1]))
  file.remove(file.path(p2, f2[i2]))
})

# rdf_to_excel() --------------
test_that("rdf_to_excel() works.", {
  expect_is(xlsx_files <- rdf_to_excel(rdfs, p1), "character")
  expect_true(all(file.exists(xlsx_files)))
  expect_setequal(
    normalizePath(xlsx_files, mustWork = FALSE),
    normalizePath(
      file.path(p1, c("KeySlots.xlsx", "SystemConditions.xlsx")),
      mustWork = FALSE
    )
  )

  new_xcel <- c("this.xlsx", "that.xlsx")
  expect_length(xlsx_files <- rdf_to_excel(rdfs, p2, new_xcel), 2)
  expect_true(all(file.exists(xlsx_files)))
  expect_setequal(
    normalizePath(xlsx_files, mustWork = FALSE),
    normalizePath(
      file.path(p2, new_xcel),
      mustWork = FALSE
    )
  )
})

# rename_excel_files() -----------------------
x1 <- c("KeySlots.xlsx", "SystemConditions.xlsx")
x2 <- c("this.xlsx", "that.xlsx")
test_that("rename_excel_files() works.", {
  expect_is(x <- rename_excel_files(x1, p1), "matrix")
  expect_equal(dim(x), c(2, 2))
  expect_true(all(file.exists(x[,2])))
  expect_true(all(file.exists(file.path(p1, paste0(test_scens[1], "-", x1)))))

  expect_is(x <- rename_excel_files(x2, p2, c("added"), "_"), "matrix")
  expect_equal(dim(x), c(2, 2))
  expect_true(all(file.exists(x[,2])))
  expect_true(all(file.exists(file.path(p2, paste0(c("added"), "_", x2)))))
})
