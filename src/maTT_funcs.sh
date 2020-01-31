#!/bin/bash

##########################################################
##########################################################
# FUNCTIONS

log() 
{
    local msg="$*"
    local dateTime=`date`
    echo "# "$dateTime "-" $log_toolName "-" "$msg"
    echo "$msg"
    echo 
}

##########################################################

get_mask_frm_aparcAseg()
{
    # inputs
    local iAparcAseg=$1
    local oDir=$2
    local subj=$3

    ## add whole brain mask based on aseg.mgz
    #mri_binarize --i ${tempFSSubj}/mri/aseg.mgz --match 2 3 7 8 10 11 12 13 16 17 18 24 26 28 30 31 41 42 46 47 49 50 51 52 53 54 58 60 62 63 77 85 251 252 253 254 255 --o ${outputDir}/mask.nii.gz

    cmd="${FREESURFER_HOME}/bin/mri_binarize \
            --i ${iAparcAseg} \
            --match 2 3 7 8 10 11 12 13 16 17 18 24 26 28 30 31 41 42 46 47 49 50 51 52 53 54 58 60 62 63 77 85 251 252 253 254 255 \
            --o ${oDir}/bmask.nii.gz \
        "    
    echo $cmd #state the command
    log $cmd >> $OUT
    eval $cmd #execute the command
    
    # make a cortical mask really fast
    cmd="${FREESURFER_HOME}/bin/mri_binarize \
            --i ${iAparcAseg} \
	    --min 1000 --max 2999 \
            --o ${oDir}/tmp.nii.gz \
        "    
    echo $cmd #state the command
    log $cmd >> $OUT
    eval $cmd #execute the command
    
    cmd="${FREESURFER_HOME}/bin/mri_binarize \
    		--i ${oDir}/bmask.nii.gz --min 1 \
		--merge ${oDir}/tmp.nii.gz \
		--o ${oDir}/mask.nii.gz \
        "    
    echo $cmd #state the command
    log $cmd >> $OUT
    eval $cmd #execute the command
  
    ls ${oDir}/tmp.nii.gz && rm ${oDir}/tmp.nii.gz
}

get_subcort_frm_aparcAseg()
{
    # inputs
    local iAparcAseg=$1
    local oDir=$2
    local subj=$3

    # initialize the subcort image, should make blank image
    #cmd="${FSLDIR}/bin/fslmaths \
    #        ${iAparcAseg} \
    #        -thr 0 -uthr 0 -bin \
    #        ${oDir}/${subj}_subcort_mask.nii.gz \
    #        -odt int \
    #    "
    cmd="${FREESURFER_HOME}/bin/mri_binarize \
            --i ${iAparcAseg} \
            --min 0 --max 0 --binval 0 \
            --o ${oDir}/${subj}_subcort_mask.nii.gz \
        "    
    echo $cmd #state the command
    log $cmd >> $OUT
    eval $cmd #execute the command

    ## now add the subcort 
    # the fs_lables correspond to labes in the image FS outputs
    local fsLabels=( 10 11 12 13 17 18 26 49 50 51 52 53 54 58 )
    # 10: Left-Thalamus-Proper
    # 11: Left-Caudate 
    # 12: Left-Putamen
    # 13: Left-Pallidum 
    # 17: Left-Hippocampus
    # 18: Left-Amygdala
    # 26: Left-Accumbens-area
    # 49: Right-Thalamus-Proper
    # 50: Right-Caudate 
    # 51: Right-Putamen
    # 52: Right-Pallidum 
    # 53: Right-Hippocampus
    # 54: Right-Amygdala
    # 58: Right-Accumbens-area

    # could use freesurfer func to speed this up lots
    local newIndex=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 )
    for (( x=0 ; x<14; x++ ))
    do

        getLabel=${fsLabels[x]}
        getIndex=${newIndex[x]}

        #cmd="${FSLDIR}/bin/fslmaths \
        #        ${iAparcAseg} \
		#        -thr ${getLabel} -uthr ${getLabel} \
        #        -binv \
        #        ${oDir}/${subj}temp${getIndex}.nii.gz"		
        cmd="${FREESURFER_HOME}/bin/mri_binarize \
                --i ${iAparcAseg} \
                --match ${getLabel} --binval 0 --binvalnot 1 \
                --o ${oDir}/${subj}temp${getIndex}.nii.gz \
            "        
        echo $cmd #state the command
        log $cmd >> $OUT
        eval $cmd #execute the command

        ### first lets make sure that there is nothhing in this subcort area
        #cmd="${FSLDIR}/bin/fslmaths \
        #        ${oDir}/${subj}_subcort_mask.nii.gz \
		#        -mas ${oDir}/${subj}temp${getIndex}.nii.gz \
		#        ${oDir}/${subj}_subcort_mask.nii.gz \
        #    "
        cmd="${FREESURFER_HOME}/bin/mri_mask \
                ${oDir}/${subj}_subcort_mask.nii.gz \
                ${oDir}/${subj}temp${getIndex}.nii.gz \
                ${oDir}/${subj}_subcort_mask.nii.gz \
            "
        echo $cmd #state the command
        log $cmd >> $OUT
        eval $cmd #execute the command

        ### reverse the label now 
        #cmd="${FSLDIR}/bin/fslmaths \
        #        ${oDir}/${subj}temp${getIndex}.nii.gz \
        #        -binv \
		#        -mul ${getIndex} \
		#        ${oDir}/${subj}temp${getIndex}.nii.gz"		
        cmd="${FREESURFER_HOME}/bin/mri_binarize \
                --i ${oDir}/${subj}temp${getIndex}.nii.gz \
                --match 1 --binval 0 --binvalnot ${getIndex} \
                --o ${oDir}/${subj}temp${getIndex}.nii.gz \        
            "
        echo $cmd #state the command
        log $cmd >> $OUT
        eval $cmd #execute the command
        
        ### add to subcort mask image now
        #cmd="${FSLDIR}/bin/fslmaths \
		#        ${oDir}/${subj}_subcort_mask.nii.gz \
		#        -add ${oDir}/${subj}temp${getIndex}.nii.gz \
		#        ${oDir}/${subj}_subcort_mask.nii.gz \
        #        -odt int \
        #    "
        cmd="${FREESURFER_HOME}/bin/mris_calc \
                --output ${oDir}/${subj}_subcort_mask.nii.gz \
                ${oDir}/${subj}temp${getIndex}.nii.gz \
                add ${oDir}/${subj}_subcort_mask.nii.gz \           
            "        
        echo $cmd
        log $cmd >> $OUT
        eval $cmd
    done
    
    # and make inverted binary mask
    #cmd="${FSLDIR}/bin/fslmaths \
	#        ${oDir}/${subj}_subcort_mask.nii.gz \
	#        -binv \
	#        ${oDir}/${subj}_subcort_mask_binv.nii.gz \
    #        -odt int \
    #    "
    cmd="${FREESURFER_HOME}/bin/mri_binarize \
            --i ${oDir}/${subj}_subcort_mask.nii.gz \
            --min 1 --inv \
            --o ${oDir}/${subj}_subcort_mask_binv.nii.gz \
        "    
    echo $cmd
    log $cmd >> $OUT
    eval $cmd    

    # remove flotsum
    ls ${oDir}/${subj}temp*.nii.gz && rm ${oDir}/${subj}temp*.nii.gz

}

##########################################################

dilate_cortex()
{

    local iCort=$1
    local iCortMask=$2
    local iSubcortMask=$3
    local tmpDir=$4

    # make temp subcort invert
    #cmd="${FSLDIR}/bin/fslmaths \
	#        ${iSubcortMask}  \
	#        -binv \
	#        ${tmpDir}/subcort_mask_inv_tmp.nii.gz \
    #        -odt int \
    #    "
    cmd="${FREESURFER_HOME}/bin/mri_binarize \
            --i ${iSubcortMask} \
            --min 1 --inv \
            --o ${tmpDir}/subcort_mask_inv_tmp.nii.gz \
        "        
    echo $cmd
    eval $cmd

    # mask out the subcort, keep temp copy
    #cmd="${FSLDIR}/bin/fslmaths \
	#	    ${iCort} \
	#	    -mas ${iSubcortMask} \
    #        ${tmpDir}/subcort_tmp.nii.gz \
    #        -odt int \
    #    "
    cmd="${FREESURFER_HOME}/bin/mri_mask \
            ${iCort} ${iSubcortMask} ${tmpDir}/subcort_tmp.nii.gz \
        "
    echo $cmd
    eval $cmd

    #get cortical parcellation without subcort
    #cmd="${FSLDIR}/bin/fslmaths \
	#	    ${iCort} \
	#	    -mas ${tmpDir}/subcort_mask_inv_tmp.nii.gz \
    #        ${tmpDir}/cort_tmp.nii.gz \
    #        -odt int \
    #    "
    cmd="${FREESURFER_HOME}/bin/mri_mask \
            ${iCort} ${tmpDir}/subcort_mask_inv_tmp.nii.gz \
            ${tmpDir}/cort_tmp.nii.gz \
        "    
    echo $cmd
    eval $cmd

    ##########################################################
    # dilate the cortex and then mask with cortical ribbon...
    # this step is done to make sure cortical ribbon is filled

    #dilate tmp cort
    cmd="atlas_dilate \
            ${tmpDir}/cort_tmp.nii.gz \
            ${tmpDir}/cort_tmp2.nii.gz \
        "
    echo $cmd
    eval $cmd

    # check if the dilate step worked
    if [[ ! -e ${tmpDir}/cort_tmp2.nii.gz ]]
    then
        return 1
    fi

    # mask this by the cortical mask
    #cmd="${FSLDIR}/bin/fslmaths \
	#	    ${tmpDir}/cort_tmp2.nii.gz \
	#	    -mas ${iCortMask} \
    #        ${tmpDir}/cort_tmp2.nii.gz \
    #        -odt int \
    #    "
    cmd="${FREESURFER_HOME}/bin/mri_mask \
            ${tmpDir}/cort_tmp2.nii.gz ${iCortMask} \
            ${tmpDir}/cort_tmp2.nii.gz \
        "      
    echo $cmd
    eval $cmd

    #remove any area that went into subcort
    #and add back in cort
    #cmd="${FSLDIR}/bin/fslmaths \
	#	    ${tmpDir}/cort_tmp2.nii.gz \
	#	    -mas ${tmpDir}/subcort_mask_inv_tmp.nii.gz \
    #        -add ${tmpDir}/subcort_tmp.nii.gz \
    #        ${iCort} \
    #        -odt int \
    #    "
    cmd="${FREESURFER_HOME}/bin/mri_mask \
            ${tmpDir}/cort_tmp2.nii.gz ${tmpDir}/subcort_mask_inv_tmp.nii.gz \
            ${tmpDir}/cort_tmp2.nii.gz \
        "      
    echo $cmd
    eval $cmd

    cmd="${FREESURFER_HOME}/bin/mris_calc \
            --output ${iCort} \
            ${tmpDir}/cort_tmp2.nii.gz \
            add ${tmpDir}/subcort_tmp.nii.gz \           
        "     
    echo $cmd
    eval $cmd  

    #remove extra stuff that was created
    ls ${tmpDir}/subcort_tmp.nii.gz && rm ${tmpDir}/subcort_tmp.nii.gz
    ls ${tmpDir}/cort_tmp.nii.gz && rm ${tmpDir}/cort_tmp.nii.gz
    ls ${tmpDir}/cort_tmp2.nii.gz && rm ${tmpDir}/cort_tmp2.nii.gz
    ls ${tmpDir}/subcort_mask_inv_tmp.nii.gz && rm ${tmpDir}/subcort_mask_inv_tmp.nii.gz

}

# experimental... option if you do not have python... but really slow
remap_parc()
{

    i_file=$1
    o_file=$2
    labs_file=$3

    # initialize remp file
    > ${o_file}_remapKey.txt

    # get labs from first colum of LUT table
    labs=($( cat ${labs_file} | awk '{print $1}' ))

    # make a blank file
    cmd="${FREESURFER_HOME}/bin/mri_binarize \
            --i ${i_file} \
            --min 0 --max 0 --binval 0 \
            --o ${o_file}_tmp.nii.gz \
        "    
    eval $cmd #execute the command

    for (( lll=0 ; lll < ${#labs[@]} ; lll++ ))
    do
        
        echo $lll

        labelVal=${labs[${lll}]}
        newVal=$(( lll + 1 ))

        cmd="${FREESURFER_HOME}/bin/mri_binarize \
                --i ${i_file} \
                --match ${labelVal} --binval ${newVal} --binvalnot 0 \
                --o ${o_file}_tmp_${newVal}.nii.gz \
            "
        eval $cmd #execute the command            
        
        # add to the new remapped image  
        cmd="${FREESURFER_HOME}/bin/mris_calc \
                --output ${o_file}_tmp.nii.gz \
                ${o_file}_tmp.nii.gz \
                add ${o_file}_tmp_${newVal}.nii.gz \           
            "        
        eval $cmd #execute the command            

        # make the remap file too
        echo "${labelVal} -> ${newVal}" >> ${o_file}_remapKey.txt

        # remove temp file
        rm ${o_file}_tmp_${newVal}.nii.gz

    done

    # new file!
    mv ${o_file}_tmp.nii.gz ${o_file}

}

##########################################################

