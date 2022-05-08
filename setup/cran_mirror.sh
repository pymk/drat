#!/bin/bash

working_dir="setup/"
r_packages_csv="${working_dir}packages.csv"

# For version numbers, see:
# https://cran.r-project.org/bin/macosx/big-sur-arm64/contrib/
# https://cran.r-project.org/bin/windows/contrib/
r_ver_mac=4.2
r_ver_win=4.3

# For macOS version names, see:
# https://cran.r-project.org/bin/macosx/
macos_ver_name=big-sur-arm64

# Should not need to change anything below this line ---------------------------

# Create a function for git workflow
# Usage: lazygit "My commit msg"
# https://stackoverflow.com/a/23328996
function lazygit() {
    git add .
    git commit -a -m "$1"
    git push
}

# Working directory and required sub-directories
cd ${working_dir}

mkdir -p "src"
mkdir -p "bin"
# mkdir -p "unzip"
# mkdir -p "build"

dir_src="${working_dir}src/"
dir_bin="${working_dir}bin/"
# dir_unzip="${working_dir}unzip/"
# dir_build="${working_dir}build/"

cran_src="https://cran.r-project.org/src/contrib/"
cran_arm="https://cran.r-project.org/bin/macosx/${macos_ver_name}-arm64/contrib/${r_ver_mac}/"
cran_x86="https://cran.r-project.org/bin/macosx/contrib/${r_ver_mac}/"
cran_win="https://cran.r-project.org/bin/windows/contrib/${r_ver_win}/"

# Sort the CSV file
sort -k1 -n -t, ${r_packages_csv} -o ${r_packages_csv}

# Loop through the CSV file
while IFS=, read -r package_name package_version
do
    pkg_id="${package_name}_${package_version}"
    pkg_src_filename="${pkg_id}.tar.gz"
    pkg_arm_filename="${pkg_id}.tgz"
    pkg_x86_filename="${pkg_id}.tgz"
    pkg_win_filename="${pkg_id}.zip"

    pkg_src_url="${cran_src}${pkg_src_filename}"
    pkg_arm_url="${cran_arm}${pkg_arm_filename}"
    pkg_x86_url="${cran_x86}${pkg_x86_filename}"
    pkg_win_url="${cran_win}${pkg_win_filename}"

    pkg_src_dir="${dir_src}${pkg_src_filename}"
    pkg_arm_dir="${dir_bin}macosx/${macos_ver_name}/contrib/${r_ver_mac}/${pkg_arm_filename}"
    pkg_x86_dir="${dir_bin}macosx/contrib/${r_ver_mac}/${pkg_x86_filename}"
    pkg_win_dir="${dir_bin}windows/contrib/${r_ver_win}/${pkg_win_filename}"

    # Download only if the file does not already exist
    if ! [ -f "${dir_src}${pkg_src_filename}" ]; then
        echo "# Downloading '${package_name}'' v${package_version} --------------------------------------------------"
        # Download + add to add to staging
        curl -L ${pkg_src_url} -o ${pkg_src_dir} --create-dirs
        Rscript add_to_github.R ${pkg_src_dir}
        
        # Download + add to add to staging
        #curl -L ${pkg_arm_url} -o ${pkg_arm_dir} --create-dirs
        #Rscript add_to_github.R ${pkg_arm_dir}

        # Download + add to add to staging
        #curl -L ${pkg_x86_url} -o ${pkg_x86_dir} --create-dirs
        #Rscript add_to_github.R ${pkg_x86_dir}

        # Download + add to add to staging
        #curl -L ${pkg_win_url} -o ${pkg_win_dir} --create-dirs
        #Rscript add_to_github.R ${pkg_win_dir}
        
        # Unzip
        # tar -xvzf "${dir_src}${pkg_src_filename}" -C ${dir_unzip}
        # Build
        # R CMD INSTALL --build "${dir_unzip}${package_name}"
        # Move built file
        # mv "${working_dir}${pkg_id}.tgz" "${dir_build}"

        # add to repository with git
        # lazygit "add ${package_name} v${package_version}"
    fi
done < ${r_packages_csv}
