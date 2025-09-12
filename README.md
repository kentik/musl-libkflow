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


## Upgrading the Go version

Upgrading the Go version in use can be done through the following steps:

### Update the base go version
- Identify the commit hash of the desired Go version from the [Go repository](https://github.com/golang/go/tags)
- Checkout that commit locally:
  - `cd $REPO_ROOT/go && git checkout $COMMIT_HASH`
- Update the go version specified in the golang job in [github workflow](./.github/workflows/build.yml)
- (Optional) Checkpoint commit:
  - `git add . && git commit -m "Update Go to $COMMIT_HASH"`
- See if the patch still applies cleanly:
  - `patch -d go -p1 < go-runtime.patch`
  - if yes, you're good to go. Push the changes and the builder will take care of the rest.
  - if no, see updating the patch below.

#### Updating the go-runtime patch

From what I can tell, the patch mitigates an issue with CGO and static linking where argv (as seen by the go runtime) 
is a nil pointer but argc is non-zero. This causes a panic in the go runtime. Fortunately, we don't care about 
arguments as we are building a static library that is configured through other means. 

The patch updates the runtime to effectively skip further configuration when argv is nil. This is done by updating 
two files in the go runtime: `$GO_ROOT/src/runtime/os_linux.go ` and `$GO_ROOT/src/runtime/runtime1.go`. The goal of 
the patch is to ensure that the created `auxvp` pointer is only accessed if argv and argc are set correctly. 

The current approach can be seen in [the patch file](./go-runtime.patch).

To create a new patch, checkout the desired version of go following the instructions above and then modify the two 
files in place to include the desired checks. 

A new diff can be created by running the following command from the root of the go submodule:
```shell
git diff > $REPO_ROOT/go-runtime.patch
```

Ensure that the patch applies cleanly by running:
```shell
patch -d go -p1 < go-runtime.patch
```

and commit.


