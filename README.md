# MUSL-libkflow

Since libkflow uses CGO internally, we need to build it with a musl c compiler to 
satisfy our end goal of producing a single statically linked kprobe binary. 
Unfortunately, creating static libraries in GO with CGO enabled only works with a
patched version of Go. 

## Creating a new version of libkflow

This guide assumes that you want to build the latest version of libkflow as it exists
on the `main` branch of the `libkflow` repository. 

### The Steps
- Update the `libkflow` submodule to the latest version
```shell
git submodule update --remote libkflow
git add .
git commit -m "Update libkflow to $LATEST_VERSION"
```
- Push the changes to github, and the builder will take care of the rest. 
- One can find the built libraries in the output of the github action.