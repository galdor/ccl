
# Print an error message and exit.
fatal() {
    printf "$*\n" >/dev/stderr
    exit 1
}

# Return the current platform used to identify the operating system and
# architecture of the current machine.
#
# The following platforms are currently supported:
# - linux-x86
# - linux-x86_64
# - linux-arm
# - darwin-ppc32
# - darwin-ppc64
# - darwin-x86
# - darwin-x86_64
# - freebsd-x86
# - freebsd-x86_64
# - solaris-x86
# - solaris-x86_64
# - windows-x86
# - windows-x86_64
ccl_platform() {
    local platform

    case $(uname -s) in
        Linux)
            case $(uname -m) in
                x86_64)    platform="linux-x86_64" ;;
                *86*)      platform="linux-x86" ;;
                *aarch64*) platform="linux-arm" ;;
                *arm*)     platform="linux-arm" ;;
            esac
            ;;

        Darwin)
            case $(arch) in
                x86_64) platform="darwin-x86_64" ;;
                i386)   platform="darwin-x86" ;;
                # TODO 64bit ppc
                ppc*)   platform="darwin-ppc32" ;;
            esac
            ;;

        CYGWIN*)
            # TODO 64bit
            platform="windows-x86"
            ;;

        SunOS)
            # TODO 64bit
            platform="solaris-x86"
            ;;

        FreeBSD)
            case $(uname -m) in
                amd64) platform="freebsd-x86_64" ;;
                i386)  platform="freebsd-x86" ;;
            esac
            ;;
    esac

    if [ -z "$platform" ]; then
        fatal "cannot identify platform"
    fi

    echo $platform
}

# Return the name of the Lisp kernel for the current platform.
ccl_kernel_name() {
    local platform name

    platform=$(ccl_platform)

    case $platform in
        linux-x86)      name="lx86cl" ;;
        linux-x86_64)   name="lx86cl64" ;;
        linux-arm)      name="armcl" ;;
        darwin-ppc32)   name="dppccl" ;;
        darwin-ppc64)   name="dppccl64" ;;
        darwin-x86)     name="dx86cl" ;;
        darwin-x86_64)  name="dx86cl64" ;;
        freebsd-x86)    name="fx86cl" ;;
        freebsd-x86_64) name="fc86cl64" ;;
        solaris-x86)    name="sx86cl" ;;
        solaris-x86_64) name="sx86cl64" ;;
        windows-x86)    name="wx86cl.exe" ;;
        windows-x86_64) name="wx86cl64.exe" ;;
    esac

    if [ -z "$name" ]; then
        fatal "no kernel found for platform '$platform'"
    fi

    echo $name
}

# Return the name of the Lisp heap image for the current platform.
ccl_image_name() {
    local platform kernel_name name

    platform=$(ccl_platform)
    kernel_name=$(ccl_kernel_name)

    case $platform in
        windows-*) name="${kernel_name%.exe}.image" ;;
        *)         name="$kernel_name.image" ;;
    esac

    echo $name
}

# Return the name of the header directory for the current platform.
ccl_header_dir_name() {
    local platform name

    platform=$(ccl_platform)

    case $platform in
        linux-x86)      name="x86-headers" ;;
        linux-x86_64)   name="x86-headers64" ;;
        linux-arm)      name="arm-headers" ;;
        darwin-ppc32)   name="darwin-x86-headers" ;;
        darwin-ppc64)   name="darwin-x86-headers64" ;;
        darwin-x86)     name="darwin-x86-headers" ;;
        darwin-x86_64)  name="darwin-x86-headers64" ;;
        freebsd-x86)    name="freebsd-headers" ;;
        freebsd-x86_64) name="freebsd-headers64" ;;
        solaris-x86)    name="solarisx86-headers" ;;
        solaris-x86_64) name="solarisx64-headers" ;;
        windows-x86)    name="win32-headers" ;;
        windows-x86_64) name="win64-headers" ;;
    esac

    if [ -z "$name" ]; then
        fatal "no header directory name found for platform '$platform'"
    fi

    echo $name
}
