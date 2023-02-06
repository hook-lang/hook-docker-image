
# Hook Docker Image

The official Hook docker image.

## What is Hook?

Hook is an imperative, cross-platform, dynamically typed scripting language with mutable value semantics.

**Warning**: Hook is still in its early stages of development and is not production-ready.

See more about Hook on [GitHub](https://github.com/fabiosvm/hook-lang).

## Docker Images

The images are based on the latest version of Alpine Linux and there are two images: the Development image and the Run image. 

The Development image sets up a workspace for you to work on the Hook project.

And the Run image has a Hook release installed so you can try it out and have fun.

## Building a image

Use the script 'docker_build.sh' to build the Hook images in the Dockerfile.alpine-hook.

Usage: ./docker_build.sh <Dockerfile|extension> [image_name]
       ./docker_build.sh Dockerfile.alpine-hook run
       ./docker_build.sh alpine-hook run
       ./docker_build.sh alpine-hook development test-bug-fix

## Running a container

Use the script 'docker_run.sh' to run a Hook image.

Usage: ./docker_run.sh <Dockerfile|extension> [image_name]
       ./docker_run.sh Dockerfile.alpine-hook run
       ./docker_run.sh alpine-hook run
       ./docker_run.sh alpine-hook run test-bug-fix

## License

This project is released under [MIT](https://choosealicense.com/licenses/mit/) license.
See [LICENSE](https://github.com/fabiosvm/hook/blob/main/LICENSE) for more details.
