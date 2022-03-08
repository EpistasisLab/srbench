git config --global user.name 'GitHub Action'
git config --global user.email 'action@github.com'
git fetch                         # fetch branches
git checkout Competition2022       # checkout to your branch
git pull origin Competition2022
# git checkout ${GITHUB_REF##*/} -- $SRC_FILE # copy files from the source branch
# mkdir -p experiment/methods/$SUBMISSION
mv submission/$SUBMISSION experiment/methods/
conda env export -n srbench-submission > experiment/methods/$SUBMISSION/environment.lock.yml
git add experiment/methods/$SUBMISSION
git diff-index --quiet HEAD ||  git commit -am "Store $SUBMISSION as competitor"  # commit to the repository (ignore if no modification)
git push origin Competition2022 # push to remote branch