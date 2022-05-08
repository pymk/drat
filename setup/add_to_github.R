if (!requireNamespace("drat", quietly = TRUE)) {
  install.packages("drat", verbose = FALSE)
}

arg_pkg <- commandArgs(trailingOnly = TRUE)
print(arg_pkg)
drat::insertPackage(
  file = arg_pkg,
  repodir = "../.",
  location = "docs",
  commit = TRUE
)
