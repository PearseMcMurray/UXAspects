#!/bin/bash

echo Workspace is $WORKSPACE
echo Build number is $BUILD_NUMBER
echo Theme is $1
echo Tarball is $2
echo UID is $UID
echo GROUPS is $GROUPS
echo USER is $USER
echo PWD is $PWD
echo HOME is $HOME

echo Moving to workspace
cd $WORKSPACE/ux-aspects

latestCommitID=`git rev-parse HEAD`
echo latestCommitID is $latestCommitID

gitPagesRepoName="UXAspects_$1_Theme_CI"
clonePagesURL="git@github.hpe.com:sepg-docs-qa/$gitPagesRepoName.git"
ghPagesCommitMessage="Build \#$BUILD_NUM Commit $latestCommitID"
docsTargetFolder="$WORKSPACE/ux-aspects/targetFolder$1"
#clonePagesURL="https://github.hpe.com/sepg-docs-qa/JobService_REL_job-service.git"
#clonePagesURL+="$gitPagesRepoName.git"

# curl https://github.hpe.com/api/v3/repos/sepg-docs-qa/??????????

# Create target folder
if [ -d "$docsTargetFolder" ]; then
    rm -rf $docsTargetFolder
fi
mkdir -p $docsTargetFolder/gh-pages

cd $docsTargetFolder/gh-pages
git clone -b gh-pages $clonePagesURL ./
git rm -rf .
tar zxvf $WORKSPACE/ux-aspects/$2 -C .
git add .
git commit --allow-empty -m \"$ghPagesCommitMessage\"
git push origin

exit 0;




################################################
#mkdir /home/jenkins/workspace/ElementsTestUser/workspace/elements_unit_tests/ux-aspects/targetFolderHPE
#cd /home/jenkins/workspace/ElementsTestUser/workspace/elements_unit_tests/ux-aspects/targetFolderHPE
#mkdir gh-pages
#tar zxvf docs-gh-pages-HPE.tar.gz -C ./gh-pages



# !create repo UXAspects_HPE_Theme_CI

# mkdir -p /home/jenkins/workspace/ElementsTestUser/workspace/elements_unit_tests/ux-aspects/tempDir/tempGHPages
# cd /home/jenkins/workspace/ElementsTestUser/workspace/elements_unit_tests/ux-aspects/tempDir/tempGHPages

# git init
# git checkout -b initial
# git config user.email "pearse.mcmurray@hpe.com"
# git config user.name "pearse-mcmurray"
# git commit --allow-empty -m \"Initial\"
# git remote add origin git@github.hpe.com:sepg-docs-qa/UXAspects_HPE_Theme_CI
# git push origin initial
# git checkout -b gh-pages
# git commit --allow-empty -m \"Initial\"
# git push origin gh-pages
# git push origin --delete gh-pages

# cd /home/jenkins/workspace/ElementsTestUser/workspace/elements_unit_tests/ux-aspects/targetFolderHPE/gh-pages
# git init
# git add .
# git commit -m \"Build \#1 Commit aaaaaaaaa\"
# git config user.email "pearse.mcmurray@hpe.com"
# git config user.name "pearse-mcmurray"
# git remote add origin git@github.hpe.com:sepg-docs-qa/UXAspects_HPE_Theme_CI
# git push -u origin master:gh-pages

# ! Set gh-pages to default branch

# cd /home/jenkins/workspace/ElementsTestUser/workspace/elements_unit_tests/ux-aspects/tempDir/tempGHPages
# git push origin --delete initial