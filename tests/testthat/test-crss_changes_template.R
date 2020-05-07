f1 <- "temp"
setup(dir.create(f1))
teardown(unlink(f1, recursive = TRUE))

test_that("crss_changes_template() works", {
  expect_error(
    crss_changes_template("this", "c:/path/that/does/not/exist/adfasdf34343")
  )

  expect_is(crss_changes_template(path = f1), "character")
  expect_is(crss_changes_template("January2020",path = f1), "character")
  expect_is(crss_changes_template("April2020.rmd",path = f1), "character")

  expect_true(file.exists(file.path(f1, "crss_changes_template.Rmd")))
  expect_true(file.exists(file.path(f1, "January2020.Rmd")))
  expect_true(file.exists(file.path(f1, "April2020.rmd")))
})
