<h1 align="center">Multi-Atlas Transfer Tool - old (w/surface output)</h1>

<p align="center">
  brainlife.io version of multi atlas transfer tools (maTT).
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/bl.app.23"><img src="https://img.shields.io/badge/Brainlife-bl.app.23-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-see_LICENSE-lightgrey.svg" alt="License"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **brainlife.io version of multi atlas transfer tools (maTT).**

brainlife.io version of multi atlas transfer tools (maTT). Specifically, this is an implementation of maTT2, which uses the gcs files trained on the mindboggle-101 data. The GCS files are automatically pulled from the maTT fishare directory if not present locally. Inputs include: freesurfer, t1, atlas. Outputs include: parc.nii.gz (for each atlas indicated) & remapped LUT text file (for each atlas indicated). These outputs are in the space of the T1w that was submitted to FreeSurfer's recon-all processes. In other words, the parc.nii.gz is resliced based on the file `rawavg.mgz` in the FreeSurfer directory. Atlases include: gordon333, nspn500, yeo17, yeo17dil, hcp-mmp, schaefer100-yeo17, and schaefer-yeo17 (200, 400, 600, 800, 1000). Check out the maTT github repo for more info and the latest version of maTT.

| | |
|---|---|
| **Inputs** | `neuro/freesurfer` |
| **Outputs** | `neuro/parcellation/volume` · `neuro/parcellation/surface-deprecated` · `neuro/mask` |
| **Container** | `faskowit/app-multiatlastt:0.0.5` |
| **Resources** | 1 CPUs · 8 GB memory · 2 h walltime |
| **Requires** | `FREESURFER_LICENSE` |
| **Run it** | [doi.org/10.25663/bl.app.23](https://doi.org/10.25663/bl.app.23) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `fsin` | `neuro/freesurfer` | yes |  |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `parc-vol` | `neuro/parcellation/volume` |  |
| `parc-surf` | `neuro/parcellation/surface-deprecated` |  |
| `mask` | `neuro/mask` |  |

<details>
<summary><b>Parameters</b> (1)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `atlas` | enum |  | Options: `gordon333dil`, `yeo17dil`, `hcp-mmp-b`, `schaefer100-yeo17`, `schaefer200-yeo17`, `schaefer400-yeo17 `, `schaefer500-yeo17`, `schaefer300-yeo17`, `shen268cort`, `baldassano`, `arslan`, `aal`, `nspn500`, `aicha`, `ica`. |

</details>

<!-- brainlife-app:end -->

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/bl.app.23](https://doi.org/10.25663/bl.app.23), choose `neuro/freesurfer` from your project, set the parameters and press **Execute**. The results are saved to your project as `neuro/parcellation/volume`, `neuro/parcellation/surface-deprecated`, `neuro/mask`.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/) (the App runs in `faskowit/app-multiatlastt:0.0.5`), [`jq`](https://jqlang.github.io/jq/), `FREESURFER_LICENSE`.

1. Clone this repository.
2. Create `config.json` with the paths to your inputs and the parameters:

   ```json
   {
       "fsin": "/path/to/fsin/fsin",
       "atlas": ""
   }
   ```

3. Run `./main`.

## Citing

If you use this App, please cite it, the software it builds on and brainlife.io:

- Multi-Atlas Transfer Tool - old (w/surface output). brainlife.io App. [doi:10.25663/bl.app.23](https://doi.org/10.25663/bl.app.23)
- Fischl, B. et al. Automatically parcellating the human cerebral cortex. Cereb. Cortex 14, 11–22 (2004)
- An acknowledgement to this github page, or the other [maTT github repo](https://github.com/faskowit/multiAtlasTT) would be appreciated.
- Fischl. FreeSurfer. *NeuroImage* 62:774-781 (2012). [doi:10.1016/j.neuroimage.2012.01.021](https://doi.org/10.1016/j.neuroimage.2012.01.021)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

- Josh Faskowitz

**Contributors**

- Soichi Hayashi

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io, which runs this App, is publicly funded by Wellcome, the U.S. National Institutes of Health and the U.S. National Science Foundation; acknowledging that support helps keep it running.</sub>

## License

See [LICENSE](LICENSE).
