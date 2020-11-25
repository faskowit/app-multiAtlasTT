# app-multiAtlasTT

ver 0.0.7

[brainlife.io](https://brainlife.io/) version of multi atlas transfer tools (maTT). This app takes in a completed `recon-all` FreeSurfer directory, and outputs a volumetric parcellation in the indiviual's T1w space. These tools warp the parcellations to the subject space using the warp information provided by FreeSurfer. This is an implemenation of maTT2, which uses the gcs files trained on the [mindboggle-101](https://mindboggle.info/data) data. The GCS files are automatically pulled from the [maTT fishare directory](https://figshare.com/articles/multiAtlasTT_data/5998583/1) if not present locally. 

Check out the [maTT github repo](https://github.com/faskowit/multiAtlasTT) for more info and the latest version of maTT.  

### Authors
- [Josh Faskowitz](jfaskowi@iu.edu)

### Contributors
- [Soichi Hayashi](hayashis@iu.edu)

### Funding Acknowledgement
brainlife.io is publicly funded and for the sustainability of the project it is helpful to Acknowledge the use of the platform. We kindly ask that you acknowledge the funding below in your publications and code reusing this code.

[![NSF-GRFP-1342962](https://img.shields.io/badge/NSF_GRFP-1342962-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1342962)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)

### Citations
We we think you should cite the following when code using this code. 

1. Fischl, B. et al. Automatically parcellating the human cerebral cortex. Cereb. Cortex 14, 11–22 (2004)
2. The doi on the brainlife platform: http://doi.org/10.25663/bl.app.23
3. An acknowledgement to this github page, or the other [maTT github repo](https://github.com/faskowit/multiAtlasTT) would be appreciated.

## Running the App 

### On Brainlife.io

You can submit this App online at [http://doi.org/10.25663/bl.app.23](http://doi.org/10.25663/bl.app.23) via the "Execute" tab.

### Running Locally (on your machine)

1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
        "fsin": "./path/to/freesurferdir/",
        "atlas": "atlasname"
}
```

*Note: the atlasname should be the name of one of the available atlases provided in the figsshare repo.*

3. Launch the App by executing `main`

```bash
./main
```

## Output

All output files will be generated under the current working directory (pwd), in directories called `parc-vol`, `parc-surf`, and `mask`. 

Inside `parc-vol` there will be:
```
parc.nii.gz
key.txt
label.json
```

Inside `parc-surf` there will be:
```
?h.parc.inflated.gii
?h.parc.pial.gii
?h.parc.white.gii
?h.parc.annot.gii
key.txt
label.json
```

Also, there is a volumetric mask in the `mask` directory. 

### Dependencies

This App uses [singularity](https://www.sylabs.io/singularity/) to run. If you don't have singularity, you can run this script in a unix enviroment with:  

  - FreeSurfer: https://surfer.nmr.mgh.harvard.edu/
  - jq: https://stedolan.github.io/jq/
  - python3 with nibabel: https://nipy.org/nibabel/

#### MIT Copyright (c) Josh Faskowitz

<sub> This material is based upon work supported by the National Science Foundation Graduate Research Fellowship under Grant No. 1342962. Any opinion, findings, and conclusions or recommendations expressed in this material are those of the authors(s) and do not necessarily reflect the views of the National Science Foundation. </sub>

