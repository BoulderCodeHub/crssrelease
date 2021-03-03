# crssrelease

<!-- badges: start -->
[![R build status](https://github.com/BoulderCodeHub/crssrelease/workflows/R-CMD-check/badge.svg)](https://github.com/BoulderCodeHub/crssrelease/actions) [![Codecov test coverage](https://codecov.io/gh/BoulderCodeHub/crssrelease/branch/master/graph/badge.svg)](https://codecov.io/gh/BoulderCodeHub/crssrelease?branch=master)
  <!-- badges: end -->

R interface to tools that help with the CRSS release process.

## Instalation

crssrelease is only available on GitHub. Install the latest released version:

```{r}
# install.packages("remotes")
remotes::install_github("BoulderCodeHub/crssrelease", "v0.1.2")
```

Install the latest development version:

```{r}
remotes::install_github("BoulderCodeHub/crssrelease")
```

## Release Process (Usage)

### Create files to post

#### For runs with multiple initializations

1. combine the rdf files together. `combine_rdfs()`. 

2. Create excel files from the rdfs. See `rdf_to_excel()`.

3. Rename the excel files so that the scenario name appears before the file name. See `rename_excel_files()`.

#### For runs with only one set of initial conditions

1. Create excel files using RiverSMART.

2. Rename the excel files so that the scenario name appears before the file name. See `rename_excel_files()`.

#### Example

```{r}
# two scenario groups
apr_dnf <- RWDataPlyr::rw_scen_gen_names(
  "Apr2020_2021,DNF,2007Dems,IG_DCP", 
  paste0("Trace", sprintf("%02d", 4:38))
)

apr_st <- RWDataPlyr::rw_scen_gen_names(
  "Apr2020_2021,ISM1988_2018,2007Dems,IG_DCP", 
  paste0("Trace", sprintf("%02d", 4:38))
)

# combine the rdfs
rdfs <- paste0(
  c('KeySlots','Flags','CRSPPowerData', 'LBDCP', 'LBEnergy', 'OWDAnn', 'Res', 
    'SystemConditions'),
  '.rdf'
)

scen_path <- "M:/Shared/CRSS/2020/Scenario"
dnf <- file.path(scen_path, "Apr2020_2021,DNF,2007Dems,IG_DCP")
dir.create(dnf)
st <- file.path(scen_path, "Apr2020_2021,ISM1988_2018,2007Dems,IG_DCP")
dir.create(st)
combine_rdfs(rdfs, apr_dnf, scen_path, dnf)
combine_rdfs(rdfs, apr_dnf, scen_path, st)

# create excel files from the combined rdfs
rdf_to_excel(rdfs, dnf)
rdf_to_excel(rdfs, st)

# rename the excel files
xlsx <- paste0(
  c('KeySlots','Flags','CRSPPowerData', 'LBDCP', 'LBEnergy', 'OWDAnn', 'Res', 
    'SystemConditions'),
  '.xlsx'
)
rename_excel_files(xlsx, c(dnf, st))
```

### CRSS Package

1. Create the CRSS zip package - see `zip_crss_package()` in zip_crss_package.R. Note that it is likely easiest to create the zip package with some of the defaults, and then delete the files/folders that are not needed.

2. Create a list of changes since the last release. `crss_changes_template()` will create a template for you that can then be knit to a pdf.

3. Add in the modeling assumptions to the zip package. 

## Releases

- v0.1.2 2021-03-03
- v0.1.1 2020-05-11
- v0.1.0 2020-05-08
