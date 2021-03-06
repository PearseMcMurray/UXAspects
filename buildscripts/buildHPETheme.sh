#!/bin/bash

UX_ASPECTS_BUILD_IMAGE_NAME=ux-aspects-build
UX_ASPECTS_BUILD_IMAGE_TAG_LATEST=0.9.0

echo Workspace is $WORKSPACE
echo HttpProxy is $HttpProxy
echo HttpsProxy is $HttpsProxy
echo Build image is $UX_ASPECTS_BUILD_IMAGE_NAME:$UX_ASPECTS_BUILD_IMAGE_TAG_LATEST
echo UID is $UID
echo GROUPS is $GROUPS
echo USER is $USER
echo PWD is $PWD
echo HOME is $HOME

echo Moving to workspace
cd $WORKSPACE/ux-aspects

# Define a function to run a specified Docker image. The job's workspace will be mapped to /workspace in the container.
# The container will run using the UID of the user executing the job.
docker_image_run()
{
    DOCKER_IMAGE_ID=`docker images | grep $UX_ASPECTS_BUILD_IMAGE_NAME | grep $UX_ASPECTS_BUILD_IMAGE_TAG_LATEST | awk '{print $3}'`
    echo ID for $UX_ASPECTS_BUILD_IMAGE_NAME:$UX_ASPECTS_BUILD_IMAGE_TAG_LATEST image is $DOCKER_IMAGE_ID
    if [ -z "$DOCKER_IMAGE_ID" ] ; then
        echo Image $UX_ASPECTS_BUILD_IMAGE_NAME:$UX_ASPECTS_BUILD_IMAGE_TAG_LATEST does not exist!
    else
        echo Calling docker run ... "$@"
        docker run --rm --volume "$PWD":/workspace --workdir /workspace --user \
		    $UID:$GROUPS $UX_ASPECTS_BUILD_IMAGE_NAME:$UX_ASPECTS_BUILD_IMAGE_TAG_LATEST "$@"
    fi
}

# Clean up previous builds
cd $WORKSPACE/ux-aspects
rm -f docs-gh-pages-HPE.tar.gz
rm -rf docs-gh-pages-HPE
rm -rf KeppelThemeFiles
rm -rf HPEThemeFiles

# Take a copy of the files which will be overwritten by the HPE theme files
echo
echo Storing the Keppel theme files
mkdir KeppelThemeFiles
cp -p -r src/fonts KeppelThemeFiles
cp -p -r src/img KeppelThemeFiles
cp -p -r src/styles KeppelThemeFiles

# Get the HPE theme files and copy them onto the source hierarchy
echo
echo Getting the HPE theme files
mkdir HPEThemeFiles
cd HPEThemeFiles
curl -L -S -s https://github.hpe.com/caf/ux-aspects-hpe/archive/master.zip > HPETheme.zip
unzip -o HPETheme.zip
cp -p -r ux-aspects-hpe-master/fonts ../src
cp -p -r ux-aspects-hpe-master/img ../src
cp -p -r ux-aspects-hpe-master/styles ../src

# Build using the HPE theme
echo
echo Building using the HPE theme
cd ..
echo Run npm install
docker_image_run npm install
echo Building
docker_image_run grunt clean
rm -rf dist
docker_image_run grunt build --force

# Archive the HPE-themed documentation files
echo
echo Archiving the HPE-themed documentation files

echo PWD is $PWD

mv dist/docs docs-gh-pages-HPE
cd docs-gh-pages-HPE
tarDocs=`tar -czvf ../docs-gh-pages-HPE.tar.gz *`
echo "$tarDocs"
cd ..

exit 0;
