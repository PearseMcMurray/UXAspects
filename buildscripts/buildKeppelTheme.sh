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
rm -f docs-gh-pages-Keppel.tar.gz
rm -rf docs-gh-pages-Keppel

# Remove the HPE theme files
echo
echo Deleting the HPE theme files
rm -rf src/fonts
rm -rf src/img
rm -rf src/styles

# Copy back the Keppel theme files
echo
echo Restoring the Keppel theme files
cp -p -r KeppelThemeFiles/* src

# Build using the Keppel theme
echo
echo Building using the Keppel theme
docker_image_run grunt clean
rm -rf dist
docker_image_run grunt build --force

# Archive the Keppel-themed documentation files
echo
echo Archiving the Keppel-themed documentation files

echo PWD is $PWD

mv dist/docs docs-gh-pages-Keppel
cd docs-gh-pages-Keppel
#tarDocs=`tar czvf ../docs-gh-pages-Keppel.tar.gz *`
echo "$tarDocs"
cd ..

exit 0;

