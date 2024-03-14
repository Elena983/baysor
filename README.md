### baysor

## Segmentation Algorithm via Baysor Xenium data

Breast cancer data from the Xenium [portal](https://www.10xgenomics.com/products/xenium-in-situ/preview-dataset-human-breast)

[the primary source and code](https://github.com/kharchenkolab/Baysor)

It is not spatial transcriptomics data but single molecule data like FISH or in-situ sequencing.

## Installation

Some insights from 10x genomics may be found [here](https://www.10xgenomics.com/analysis-guides/using-baysor-to-perform-xenium-cell-segmentation)

--------------------------------------------------
```bash
julia -e 'using Pkg; Pkg.add(PackageSpec(url="https://github.com/kharchenkolab/Baysor.git")); Pkg.build()'
```

```bash
curl -fsSL https://install.julialang.org | sh
```
---------------------------------------------------

Only the transcripts.csv.gz file will be needed.

Download Micromamba and the required modules (pandas, scipy, pyarrow) and create the environment.
Prepare Xenium data for the baysor algorithm running (python script - filter_transcripts.py) to get filtered_transcripts.csv.

1. Filter out negative control transcripts.
   
2. Filter out transcripts whose Q-Score falls below a specified threshold (default: 20).
Since Baysor errors out if the cell_id column contains negative integers, it is necessary to modify the cell_id value from -1 to 0 for transcripts not associated with cells.

3. As a bonus, the script can also be used to subset the dataset (e.g., only keep transcripts whose x_location is < 1000 microns) and facilitate faster iterations of parameter-tuning.

You can find the folder where baysor is installed and run all commands.

#Preview command to see preliminary data

![image](https://github.com/Elena983/baysor/assets/68946912/b49d177b-4fc3-46e6-9371-cd30afa46756)

![image](https://github.com/Elena983/baysor/assets/68946912/b2f135f1-0eea-4d76-8ea7-63dd76ed5f52)

#The Baysor HTML files with cluster and polygon images. 

Baysor segmentation. Run

![image](https://github.com/Elena983/baysor/assets/68946912/38955390-2944-4448-9cea-90b4dd86f6a1)

Borders to estimate the quality. Then, we may adjust the parameters.

![image](https://github.com/Elena983/baysor/assets/68946912/3377553c-3030-4be1-bc12-409aa512a022)

Clustering

![image](https://github.com/Elena983/baysor/assets/68946912/005ab003-7dd0-437a-9193-b99eb5143767)

After the main run, we may analyze the received segmentation.csv

As we can see, we got 118K cells in good Xenium segmentation data and expected the number of cells to be around 100k, but we got 330k from the 10x bays or tutorial.
They recommend not to specify the crucial -s parameter. 
That value indicates the approximate cell radius, which may be stated only by eye now. 
So, we allowed the algorithm to define the radius of the cells found.

Then, I applied different settings to find the best options for the Baysor.

The best ones were obtained using the deepcell mask with -s 20 (95k) or Xenium segmentation column in the data with the same cell radius (104k).

After cell segmentation, we must transform segmentation.csv to the appropriate format for tools like Seurat or Scipy (python script - map_transcripts.py).

![image](https://github.com/Elena983/baysor/assets/68946912/457f711e-9efb-46a7-a2c1-a80a59e3b08a)

Quality control of segmentation.csv and segmentation_stats.csv files

![image](https://github.com/Elena983/baysor/assets/68946912/09e91075-aa44-4477-b8d2-edbb005faa69)

Exploring default Xenium segmentation data

![image](https://github.com/Elena983/baysor/assets/68946912/4e28aea8-3feb-4e5f-9fcd-768fcfb9b1fc)

Clusterization is done without any dimensional reduction using the Vojager Package (by Lior Pacher) 










