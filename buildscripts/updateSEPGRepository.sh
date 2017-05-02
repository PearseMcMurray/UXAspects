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

clonePagesURL="git@github.hpe.com:sepg-docs-qa/"
ghPagesCommitMessage="Build #$BUILD_NUM Commit $latestCommitID"
docsTargetFolder="$WORKSPACE/ux-aspects/targetFolder$1"
gitPagesRepoName="UXAspects_$1_Theme_CI"
clonePagesURL="https://github.hpe.com/sepg-docs-qa/JobService_REL_job-service.git" #clonePagesURL + gitPagesRepoName + ".git"

# Create target folder
if [ -d "$docsTargetFolder" ]; then
    rm -rf $docsTargetFolder
fi
mkdir $docsTargetFolder

cd $docsTargetFolder
mkdir gh-pages
cd gh-pages
git clone -b gh-pages $clonePagesURL ./
#git rm -rf .
#tar zxvf $WORKSPACE/ux-aspects/$2 -C .
#git add .
#git commit --allow-empty -m \"$ghPagesCommitMessage\"
#git push origin

exit 0;
