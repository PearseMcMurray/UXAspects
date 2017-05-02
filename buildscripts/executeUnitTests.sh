#!/bin/bash

UX_ASPECTS_BUILD_IMAGE_NAME=ux-aspects-build
UX_ASPECTS_BUILD_IMAGE_TAG_LATEST=0.9.0

echo
echo
echo Workspace is $WORKSPACE
echo HttpProxy is $HttpProxy
echo HttpsProxy is $HttpsProxy
echo Build number is $BUILD_NUMBER
echo Build image is $UX_ASPECTS_BUILD_IMAGE_NAME:$UX_ASPECTS_BUILD_IMAGE_TAG_LATEST
echo UID is $UID
echo GROUPS is $GROUPS
echo GID is $GID
echo EUID is $EUID
echo USER is $USER
echo PWD is $PWD
echo HOME is $HOME

echo Displaying groups
groups
echo Displaying id
id

# Define a function to build a specified Docker image.
docker_image_build()
{
    DOCKER_IMAGE_ID=`docker images | grep $UX_ASPECTS_BUILD_IMAGE_NAME | grep $UX_ASPECTS_BUILD_IMAGE_TAG_LATEST | awk '{print $3}'`
    echo ID for $UX_ASPECTS_BUILD_IMAGE_NAME:$UX_ASPECTS_BUILD_IMAGE_TAG_LATEST image is $DOCKER_IMAGE_ID
    if [ -z "$DOCKER_IMAGE_ID" ] ; then
        # Create the docker image
        cd $WORKSPACE/ux-aspects/docker
        echo Building the image
        docker build -t $UX_ASPECTS_BUILD_IMAGE_NAME:$UX_ASPECTS_BUILD_IMAGE_TAG_LATEST \
            --build-arg http_proxy=$HttpProxy \
            --build-arg https_proxy=$HttpsProxy \
            --build-arg no_proxy="localhost, 127.0.0.1" \
            --no-cache .
        DOCKER_IMAGE_ID=`docker images | grep $UX_ASPECTS_BUILD_IMAGE_NAME | grep $UX_ASPECTS_BUILD_IMAGE_TAG_LATEST | awk '{print $3}'`
        echo ID for new $UX_ASPECTS_BUILD_IMAGE_NAME:$UX_ASPECTS_BUILD_IMAGE_TAG_LATEST image is $DOCKER_IMAGE_ID
    fi
}

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
        docker run --rm --volume "$PWD":/workspace --workdir /workspace \
		    --user $UID:$GROUPS $UX_ASPECTS_BUILD_IMAGE_NAME:$UX_ASPECTS_BUILD_IMAGE_TAG_LATEST "$@"
    fi
}

cd $WORKSPACE/ux-aspects

# Create the latest elements-build image if it does not exist
docker_image_build; echo

# Build using the HPE theme
echo Build using the HPE theme
bash buildscripts/buildHPETheme.sh
echo

# Build using the Keppel theme
echo Build using the Keppel theme
bash buildscripts/buildKeppelTheme.sh
echo

# Update the HPE theme respository
echo Update the HPE theme respository
bash buildscripts/updateSEPGRepository.sh "HPE" "docs-gh-pages-HPE.tar.gz"
echo

# Update the Keppel theme respository
echo Update the Keppel theme respository
bash buildscripts/updateSEPGRepository.sh "Keppel" "docs-gh-pages-Keppel.tar.gz"
echo

exit 0;
