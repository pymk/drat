## Private R Package Repository

The goal of this project is to set up an automated way to add multiple version of an R package to a private GitHub repo using scripts and `drat` package.

This is a test project and not meant to be used in production.

---

### Workflow

The workflow consists of:

1. Updating a CSV file with the name of the R package and the CRAN version of interest.
2. Running a shell script

The script will automatically download the requested packages and uploads them to the GitHub repo.

---

### Setup

There are two workhorse behind this automation: the `drat` R package and the shell script.

The `drat` package does the heavy lifting for creating the CRAN-style GitHub repo and the required files. The script does the downloading and running the `drat` function.

- First, set up a GitHub repo according to [these instructions](https://eddelbuettel.github.io/drat/vignettes/dratstepbystep/).
- Secondly, git needs to be configured to connect to the GitHub account.
- And finally, the `cran_mirror.sh` file should be updated. Specifically, the `working_dir` variable should point to the directory that is linked to the GitHub repo that will be used.

The "clean" structure would look like this:

```
├── add_to_github.R
├── cran_mirror.sh
├── docs
│  ├── _config.yml
│  ├── index.md
├── packages.csv
└── README.md
```

All the other files and directories in [my example repo](https://github.com/pymk/minicran) (e.g. "PACKAGES", "bin", "src", etc) will be created as part of the process.

---

### Usage

Upon updating the `packages.csv` file with the desired R package name and version, run the `cran_mirror.sh` in terminal. Once the process is complete, users can download R packages from the repo with:

```r
install.packages("<package-name>", repos = "https://<github-account>.github.io/<repo-name>")

# Example
# install.packages("zoo", repos = "https://pymk.github.io/minicran")
```
