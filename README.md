# baysor
segmentation via baysor

Breast cancer data from Xenium portal
https://www.10xgenomics.com/products/xenium-in-situ/preview-dataset-human-breast

the primary source and code
https://github.com/kharchenkolab/Baysor

It is not spatial transcriptomics data but single molecule data like FISH or in-situ sequencing.

Installation

Some insights may be found here
https://www.10xgenomics.com/analysis-guides/using-baysor-to-perform-xenium-cell-segmentation
-----------------------------
curl -fsSL https://install.julialang.org | sh

julia -e 'using Pkg; Pkg.add(PackageSpec(url="https://github.com/kharchenkolab/Baysor.git")); Pkg.build()'

-----------------------------

Only the transcripts.csv.gz file will be needed.

Download Micromamba and the required modules (pandas, scipy, pyarrow) and create the environment.
Prepare Xenium data for the baysor algorithm running (python script - filter_transcripts.py) to get filtered_transcripts.csv.

1. Filter out negative control transcripts.
   
2. Filter out transcripts whose Q-Score falls below a specified threshold (default: 20).
Since Baysor errors out if the cell_id column contains negative integers, it is necessary to modify the cell_id value from -1 to 0 for transcripts not associated with cells.

3. As a bonus, the script can also be used to subset the dataset (e.g. only keep transcripts whose x_location is < 1000 microns) and facilitate faster iterations of parameter-tuning.

You can find the folder where baysor is installed and run all commands.

Preview command to see preliminary data

![image](https://github.com/Elena983/baysor/assets/68946912/b49d177b-4fc3-46e6-9371-cd30afa46756)

![image](https://github.com/Elena983/baysor/assets/68946912/2883b4cd-3c2b-42c7-932a-afe46421c121)

Baysor segmentation. Run

![image](https://github.com/Elena983/baysor/assets/68946912/38955390-2944-4448-9cea-90b4dd86f6a1)

Borders to estimate the quality. Then, we may adjust the parameters.

![image](https://github.com/Elena983/baysor/assets/68946912/3377553c-3030-4be1-bc12-409aa512a022)

Clustering

![image](https://github.com/Elena983/baysor/assets/68946912/005ab003-7dd0-437a-9193-b99eb5143767)

After cell segmentation, we must transform segmentation.csv to the appropriate format for tools like Seurat or Scipy (python script - map_transcripts.py).

![image](https://github.com/Elena983/baysor/assets/68946912/457f711e-9efb-46a7-a2c1-a80a59e3b08a)








