BATTEN=$1
VCF=$2
SNV_CALLER="mutect_smchet"
CNV_CALLER="battenberg-smchet"
CNV_CONFIDENCE=1
READ_LENGTH=100
MCMC=1
BURNIN=1
NCHAINS=3
RANDOM_SEED="`seq 1 ${NCHAINS}`"
#TODO: Fix cellularity
#TODO: subsampling
#if $subsample.run == "yes":
#--sample-size ${subsample.count}
#end if
#TODO: normal-cn
#if $only_normal_cn
#--only-normal-cn 
#end if

python /opt/phylowgs/parser/parse_cnvs.py --cnv-format $CNV_CALLER --cellularity 1.0 --cnv-output cnvs.txt $BATTEN

python /opt/phylowgs/parser/create_phylowgs_inputs.py --cnvs s1=cnvs.txt --output-cnvs cnv_data.txt --output-variants ssm_data.txt --vcf-type s1=$SNV_CALLER s1=$VCF
python /opt/phylowgs/multievolve.py --num-chains $NCHAINS --ssms ssm_data.txt --cnvs cnv_data.txt --burnin-samples $BURNIN --mcmc-samples $MCMC -r $RANDOM_SEED

python /opt/phylowgs/write_results.py tumour /opt/chains/trees.zip trees.json.gz mutations.json.gz mutation_assignments.json.gz

PYTHONPATH='/opt/phylowgs/' python /opt/smchet-challenge/create-smchet-report/write_report.py trees.json.gz mutations.json.gz mutation_assignments.json.gz /opt/outputs