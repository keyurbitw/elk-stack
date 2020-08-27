cd /home/jenkins/workspace/TestPipeline/elk-stack
FILES=$(ls *.yaml)
for file in $FILES
do
  echo "Validating $file"
  python -c 'import yaml, sys; yaml.safe_load(sys.stdin)' < $file
  statuscode=$(echo $?)
  if [ $statuscode -eq 0 ]
  then
    echo "$file was proper yaml file"
  else
    echo "$file is not in proper yaml format. Please modify it"
  fi
done
