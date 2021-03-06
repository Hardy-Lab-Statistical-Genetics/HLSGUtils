% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CSVJoinDelta.R
\name{CSVJoinDelta}
\alias{CSVJoinDelta}
\title{Read CSV File and Merge with Delta Big Datasets}
\usage{
CSVJoinDelta(csvPath, deltaPath, byX, byY, savePath, cores = 4)
}
\arguments{
\item{csvPath}{CSV File Path}

\item{deltaPath}{Delta File Path}

\item{byX}{Name of First data column Used for Merging}

\item{byY}{Name of Second data column Used for Merging}

\item{savePath}{CSV Save Path}

\item{cores}{Spark local number of cores}
}
\value{

}
\description{
Read CSV File and Merge with Delta Big Datasets
}
