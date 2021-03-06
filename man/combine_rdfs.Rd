% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/combine_rdfs.R
\name{combine_rdfs}
\alias{combine_rdfs}
\title{Combine rdf files for a set of scenarios}
\usage{
combine_rdfs(rdfs, scenarios, scen_path, out_path)
}
\arguments{
\item{rdfs}{A vector of rdf(s) to combine. There will be one rdf file
created for each provided rdf file.}

\item{scenarios}{A vector of scenarios. The specified \code{rdf} will be combined
from all \code{scenarios}.}

\item{scen_path}{Top level directory of all the specified \code{scenarios}.}

\item{out_path}{Where to save the combined rdfs.}
}
\value{
Invisibly returns a vector of the file names of all the rdfs that
were created.
}
\description{
\code{combine_rdfs()} creates one rdf file containing data for that rdf file from
multiple scenarios.
}
\examples{
\dontrun{
scens <- "Apr2020_2021,DNF,2007Dems,IG_DCP,MTOM_Most"
rdfs <- paste0(c('KeySlots','Flags'),'.rdf')
scen_path <- 'M:/Shared/CRSS/2020/Scenario'
x <- combine_rdfs(rdfs, scens, scen_path, "C:/test")

# the following would be c(TRUE, TRUE)
x == c("C:/test/KeySlots.rdf", "C:/test/Flags.rdf")
}

}
