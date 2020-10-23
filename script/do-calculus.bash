#!/bin/bash
# set -e

archive_book_url="https://archive.cnx.org/contents/8b89d172-2927-466f-8661-01abc7ccdba4@7.4"

if [[ $0 != "-bash" ]]; then
  cd "$(dirname "$0")/.." || exit 111
fi


wget ${archive_book_url} --header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/*;q=0.8" --base=${archive_book_url} --mirror --force-html --continue --timeout=45 --convert-links --recursive --page-requisites --no-parent --domains=cnx.org
exit_status=$?
if [[ ${exit_status} != 0 && ${exit_status} != 8 ]]; then
  echo "wget encountered an error. The status code was ${exit_status}"
  exit 111
fi

echo "Changing inter-module links to cnx.org"
all_content=$(find archive.cnx.org/contents -name "*:*.html")
for filename in ${all_content}; do

  mv "${filename}" temp.html
  xsltproc --output "${filename}" ./script/link-rewriter.xsl temp.html
  rm temp.html

  # xsltproc ./script/link-rewriter.xsl "${filename}" > /dev/null
done

echo "Renaming resources to not include the filename"
all_resources=$(find archive.cnx.org/resources -type f)

for filename in ${all_resources}; do
  dirname=$(dirname ${filename})

  # If the destination (dirname) exists then do not rename
  if [[ ${dirname} == 'archive.cnx.org/resources' ]]; then
    echo "Skipping ${filename}"
  else
    echo "renaming ${filename} to ${dirname}"

    mv ${filename} temp.image || exit 111
    rm -rf ${dirname} || exit 111
    mv temp.image ${dirname} || exit 111
  fi
done


# Generate a mapping so the docx files are sanely named
# see https://stackoverflow.com/a/3467959
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_054c519f_91dd_4df7_b604_050ff3e3e6fc_19_html=Preface"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_1f64cb6f_6f92_4ee8_a4e7_9c20c6eed1e7_4_html=1 Introduction"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_7cfe0552_bc12_452e_9c56_418ec508a280_8_html=1.1 Review of Functions"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_d39e9c40_7f01_4254_aaa8_8da23ce7621b_11_html=1.2 Basic Classes of Functions"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_6e565dfe_80df_4361_96f3_4eb5aa11e52d_6_html=1.3 Trigonometric Functions"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_21bf0e2b_d95b_4e26_b9b9_fb7179ceaed1_8_html=1.4 Inverse Functions"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_4e380129_1af7_4fd5_a8e8_2893f56fb2de_13_html=1.5 Exponential and Logarithmic Functions"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_2a6062b4_d400_5a5a_a3cf_660410a5c68f_7_4_html=1 Key Terms"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_1c5bdbbc_3615_5cf8_b94f_8e15c64ffc9f_7_4_html=1 Key Equations"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_1d544a46_4a90_57ca_895d_d8567bb671cb_7_4_html=1 Key Concepts"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_7916b35f_08db_5e58_8659_19fd417d0a6a_7_4_html=1 Chapter Review Exercises"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_7ebb4d1b_98e5_4f5f_a950_b097168c8130_5_html=2 Introduction"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_caf3fc11_a5f5_49c6_b3c3_31d84cb93751_11_html=2.1 A Preview of Calculus"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_74a09fc9_5f6e_4f6d_a6da_b13c909ad307_8_html=2.2 The Limit of a Function"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_fb10befb_c5c7_46f4_b066_10f3f7131b52_11_html=2.3 The Limit Laws"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_789d3c02_cb97_4f5f_9193_489f0a0cf050_7_html=2.4 Continuity"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_8d2b312f_0cc4_4c97_adbc_edb41bf05137_7_html=2.5 The Precise Definition of a Limit"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_3098a615_8f1a_5344_aedb_d3bbd3101c70_7_4_html=2 Key Terms"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_0e70d549_c5b8_54a1_9984_c1f337de82d3_7_4_html=2 Key Equations"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_0cfbce8b_a577_5495_bd57_a1e499e91c25_7_4_html=2 Key Concepts"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_b079a7be_b271_56a8_a6b7_d9b33f95a8d6_7_4_html=2 Chapter Review Exercises"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_b56f3f62_f26d_4a04_a9fd_dd9bb6e23fda_4_html=3 Introduction"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_874f263f_c81b_42ff_9d4f_0fc8db63974c_7_html=3.1 Defining the Derivative"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_272d1a59_5e99_4a80_90e1_ccf60fb3cc1c_11_html=3.2 The Derivative as a Function"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_f1a25413_3af2_4f97_8aac_dd75a16c8aea_9_html=3.3 Differentiation Rules"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_610ace30_270f_4dfc_8fad_5e44c4723919_8_html=3.4 Derivatives as Rates of Change"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_147ddf25_f9d0_479f_be13_eab353ffee90_10_html=3.5 Derivatives of Trigonometric Functions"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_ec67b972_681d_403b_b456_82729dae0b91_10_html=3.6 The Chain Rule"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_afb02c92_f502_4a0f_91cf_793930632bd6_8_html=3.7 Derivatives of Inverse Functions"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_19fcb009_6677_4691_bf1a_a8d40e32bf11_9_html=3.8 Implicit Differentiation"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_40fef24a_e790_49bf_9c6a_edc93696b724_7_html=3.9 Derivatives of Exponential and Logarithmic Functions"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_db241533_1d8a_5ba4_aea9_afbddd5eef2d_7_4_html=3 Key Terms"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_ba1c9416_354d_59a3_9a28_e3363885cae2_7_4_html=3 Key Equations"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_00970ccf_218e_513a_962e_38181b4195e7_7_4_html=3 Key Concepts"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_79ded80e_c1bd_54b3_ac9b_151dfaece5ce_7_4_html=3 Chapter Review Exercises"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_7709b0cf_003a_479c_bd44_521eadfff68a_4_html=4 Introduction"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_ef8bd00f_7d2e_47a5_a840_2be08285798a_9_html=4.1 Related Rates"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_dbb1a1c8_9eb0_482b_9ded_66588adef938_6_html=4.2 Linear Approximations and Differentials"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_f3849900_d1cd_44c9_96ae_f30447c4cd35_8_html=4.3 Maxima and Minima"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_431f7dd4_c3b4_46e3_aa21_dead3e83a5f4_8_html=4.4 The Mean Value Theorem"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_ce336553_5ce0_4a5d_afcb_21187fc5b29b_8_html=4.5 Derivatives and the Shape of a Graph"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_319a7d02_7432_42d8_aec3_7274b5591ceb_17_html=4.6 Limits at Infinity and Asymptotes"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_b2fca278_57bd_421d_aa85_21f539b4cc6f_7_html=4.7 Applied Optimization Problems"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_bb6e333c_402d_4401_b750_4faac36169ff_14_html=4.8 L&#8217;H&#244;pital&#8217;s Rule"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_c0e46c4d_3d5c_400e_a3b9_af3cb3e066e2_5_html=4.9 Newton&#8217;s Method"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_315fd30e_9061_44bc_8c4f_2db55d620f25_7_html=4.10 Antiderivatives"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_a10148f1_af44_5c54_9377_a0971ef96f1a_7_4_html=4 Key Terms"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_e4b378ea_b2e1_5956_826a_da4a4ee6852f_7_4_html=4 Key Equations"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_0644cbeb_a390_5f71_b654_78170ebf149f_7_4_html=4 Key Concepts"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_098e8cb4_0d1b_597d_87b3_33cd9cf25824_7_4_html=4 Chapter Review Exercises"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_aebce6b3_aacf_45ce_86d3_44925fc0a4e6_6_html=5 Introduction"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_30cf4f11_db33_41bf_aa24_3dd0650b7d0b_7_html=5.1 Approximating Areas"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_e3ff3567_a949_4c81_a266_c5dc47b654ad_8_html=5.2 The Definite Integral"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_ae7e03b0_1054_4c54_8211_a6411bd440ff_10_html=5.3 The Fundamental Theorem of Calculus"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_71cde57b_d60f_4143_ba88_a7a1fde3dae2_9_html=5.4 Integration Formulas and the Net Change Theorem"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_c311f572_14dc_47ed_89b1_3997a0c80e4c_12_html=5.5 Substitution"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_b05b4322_00d3_48e5_b476_66ceaa747220_6_html=5.6 Integrals Involving Exponential and Logarithmic Functions"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_100d4b89_50fd_47f5_b530_99221cb6a5bd_11_html=5.7 Integrals Resulting in Inverse Trigonometric Functions"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_f3615e01_d65e_5dff_b763_d38706aadd9c_7_4_html=5 Key Terms"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_bb3d47dd_5812_5c76_8901_f03523cbd249_7_4_html=5 Key Equations"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_bd25355f_7cc1_58ba_9d29_f10eb0b63122_7_4_html=5 Key Concepts"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_7b64b0b3_f572_5b31_bb11_ed49d31d42db_7_4_html=5 Chapter Review Exercises"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_0e9b28ca_f080_4d11_add1_28820fd7b281_6_html=6 Introduction"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_0d216b57_b657_418d_87a4_3f5474dc1750_8_html=6.1 Areas between Curves"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_053bfd25_c130_4dcb_9b51_41790a4db886_6_html=6.2 Determining Volumes by Slicing"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_fcd8bb49_9f9c_41ea_89e8_72eb34aed9fb_6_html=6.3 Volumes of Revolution_ Cylindrical Shells"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_8e57d53e_4025_4fcf_af30_0aa16381df10_7_html=6.4 Arc Length of a Curve and Surface Area"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_01383df4_190d_426f_906e_060c203b744d_7_html=6.5 Physical Applications"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_8f2b4f6e_e851_4e59_a2c6_9f2bb0c7887b_6_html=6.6 Moments and Centers of Mass"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_010e59af_566e_430f_809f_a99ce444bac2_7_html=6.7 Integrals, Exponential Functions, and Logarithms"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_0e8f2277_0157_429c_b3bf_f74d6487e4b8_8_html=6.8 Exponential Growth and Decay"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_a638202c_6a3c_4dc8_a598_4aab3650ac84_7_html=6.9 Calculus of the Hyperbolic Functions"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_1160a2e5_82a5_52ac_9177_8fbe10be85e6_7_4_html=6 Key Terms"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_d6d3b518_85f4_5e6b_afd9_ad833298dd2d_7_4_html=6 Key Equations"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_794005e5_27d6_5fb5_aa0d_fd43951f9517_7_4_html=6 Key Concepts"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_0b0909ba_8e14_56fb_a93d_c24fc646f072_7_4_html=6 Chapter Review Exercises"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_11340fed_e663_401b_a4c8_6956078f569c_10_html=A | Table of Integrals"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_a5a5a2aa_3a35_4c5e_947f_9ae5da92edcb_10_html=B | Table of Derivatives"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_3be3840a_d419_4680_a09e_8dea36bacbf7_10_html=C | Review of Pre_Calculus"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_cfd44847_1421_5845_9f39_6dfb7e31d9f1_7_4_html=Chapter 1"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_3d449028_80b8_5707_89b2_35672d46f26d_7_4_html=Chapter 2"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_a329ca25_ddf9_5b35_8d21_8a816d63bb2d_7_4_html=Chapter 3"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_7265e10b_69e4_5921_9a2c_5b70f7e010bd_7_4_html=Chapter 4"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_ef79875c_6cea_55f7_8864_af5f8f593b5a_7_4_html=Chapter 5"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_42e940c0_7a50_5ab4_92cf_4749913ed40d_7_4_html=Chapter 6"
declare "contentkey_8b89d172_2927_466f_8661_01abc7ccdba4_7_4_0abf5180_0395_59bb_9e7c_603abeadbe20_7_4_html=Index"


echo "Convert HTML to docx and put them in the output/ directory"

[[ -d ./output/ ]] || mkdir ./output/ || exit 111

rm archive.cnx.org/contents/*.temp.html

all_content=$(find archive.cnx.org/contents -name "*:*.html")
for filename in ${all_content}; do

  base_name=$(basename ${filename})
  # replace '.' and ':' in the ident with _ so it can be looked up in the map
  base_name=${base_name//./_}
  base_name=${base_name//:/_}
  base_name=${base_name//@/_}
  base_name=${base_name//-/_}

  i="contentkey_${base_name}"
  human_name="${!i}"

  docx_file="output/${human_name}.docx"

# TODO: convert MathML to PNG


  echo "Generating '${docx_file}' using ${base_name}"

  ./script/html-to-docx.bash ${filename} "${docx_file}"
done